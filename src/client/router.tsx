import { lazy, type ComponentType } from 'react';
import { createBrowserRouter, Navigate, Outlet, type RouteObject, useLocation, useSearchParams } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { Toaster } from 'react-hot-toast';
import { useSession } from '@/client/api/session';
import { AppShell } from '@/client/ui/AppShell';
import { DialogProvider } from '@/client/ui/Dialog';
import { HintsProvider } from '@/client/ui/hints';
import { NotificationsProvider, ToastReaper } from '@/client/ui/Notifications';
import { SettingsProvider } from '@/client/ui/settings';
import { Spinner } from '@/client/ui/controls';
import { MatchProvider } from '@/client/screens/matchContext';
import { Seo } from '@/client/components/Seo';

const queryClient = new QueryClient({ defaultOptions: { queries: { retry: 1, refetchOnWindowFocus: false } } });

const Splash = () => (
  <div className="app-bg dvh flex items-center justify-center">
    <Spinner />
  </div>
);

/** Providers every screen needs. Lives inside the router so they can navigate. */
function RootLayout() {
  return (
    <QueryClientProvider client={queryClient}>
      <SettingsProvider>
        <DialogProvider>
          <MatchProvider>
            <HintsProvider>
              <NotificationsProvider>
                <Seo />
                <ToastReaper />
                <Toaster
                  position="top-center"
                  toastOptions={{
                    style: { background: 'rgba(11,9,51,0.96)', color: '#f4f3ff', border: '1px solid rgba(255,255,255,0.18)', borderRadius: 6, fontFamily: 'Barlow, sans-serif' },
                    success: { iconTheme: { primary: '#3df08a', secondary: '#0b0933' } },
                    error: { iconTheme: { primary: '#ff5470', secondary: '#0b0933' } },
                  }}
                />
                <Outlet />
              </NotificationsProvider>
            </HintsProvider>
          </MatchProvider>
        </DialogProvider>
      </SettingsProvider>
    </QueryClientProvider>
  );
}

// Signed-out visitors only (login, signup): signed-in players go back where they came from.
function GuestRoute() {
  const session = useSession();
  const location = useLocation();
  const [params] = useSearchParams();
  const redirect = params.get('_redirect') ? decodeURIComponent(params.get('_redirect')!) : '/';
  if (session.status === 'loading') return <Splash />;
  if (session.status === 'needsProfile') return <Navigate to="/welcome" replace />;
  if (session.status === 'in') return <Navigate to={redirect} state={{ from: location }} replace />;
  return <Outlet />;
}

// Signed-in players only: others are sent to sign in and come back afterwards.
function PrivateRoute() {
  const session = useSession();
  const location = useLocation();
  if (session.status === 'loading') return <Splash />;
  if (session.status === 'out') {
    return <Navigate to={`/login?_redirect=${encodeURIComponent(location.pathname + location.search)}`} state={{ from: location }} replace />;
  }
  if (session.status === 'needsProfile' && location.pathname !== '/welcome') return <Navigate to="/welcome" replace />;
  return <Outlet />;
}

type Loader = () => Promise<{ default: ComponentType }>;
const L = (loader: Loader) => lazy(loader);
const named = <T extends Record<string, ComponentType>>(m: Promise<T>, key: keyof T) => m.then((x) => ({ default: x[key] as ComponentType }));

const routes: RouteObject[] = [
  {
    Component: RootLayout,
    children: [
      {
        Component: AppShell,
        children: [
          { path: '/', Component: L(() => import('@/client/screens/HomeScreen')) },
          { path: '/practice', Component: L(() => import('@/client/screens/PracticeScreen')) },
          { path: '/settings', Component: L(() => import('@/client/screens/SettingsScreen')) },
          { path: '/terms', Component: L(() => named(import('@/client/screens/LegalScreens'), 'TermsScreen')) },
          { path: '/privacy', Component: L(() => named(import('@/client/screens/LegalScreens'), 'PrivacyScreen')) },
          {
            Component: GuestRoute,
            children: [
              { path: '/login', Component: L(() => named(import('@/client/screens/AuthScreens'), 'LoginScreen')) },
              { path: '/signup', Component: L(() => named(import('@/client/screens/AuthScreens'), 'SignupScreen')) },
              { path: '/reset-password', Component: L(() => named(import('@/client/screens/AuthScreens'), 'ResetPasswordScreen')) },
            ],
          },
          {
            Component: PrivateRoute,
            children: [
              { path: '/welcome', Component: L(() => named(import('@/client/screens/AuthScreens'), 'WelcomeScreen')) },
              { path: '/world-cup', Component: L(() => import('@/client/screens/WorldCupScreen')) },
              { path: '/online', Component: L(() => import('@/client/screens/OnlineScreen')) },
              { path: '/profile', Component: L(() => import('@/client/screens/ProfileScreen')) },
              { path: '/club', Component: L(() => import('@/client/screens/ClubScreen')) },
              { path: '/leaderboard', Component: L(() => import('@/client/screens/LeaderboardScreen')) },
            ],
          },
          { path: '/logout', Component: L(() => import('@/client/screens/LogoutScreen')) },
          { path: '*', Component: L(() => named(import('@/client/screens/LegalScreens'), 'NotFoundScreen')) },
        ],
      },
      // The match is its own full-screen world, outside the menu frame.
      { path: '/match', Component: L(() => import('@/client/screens/MatchScreen')) },
      ...(import.meta.env.DEV ? [{ path: '/dev/loopback', Component: L(() => import('@/client/pages/DevLoopbackPage')) }] : []),
    ],
  },
];

export const router = createBrowserRouter(routes);
