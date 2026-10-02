import { useEffect, useState } from 'react';
import { NavLink, Outlet, useLocation, useNavigate } from 'react-router-dom';
import { Globe, House, Settings as Gear, Target, Trophy, WifiOff } from 'lucide-react';
import { useSession } from '@/client/api/session';
import { Avatar } from './controls';
import { HintBar } from './hints';
import { NotificationBell } from './Notifications';
import { MenuNav } from './MenuNav';

const TABS = [
  { to: '/', label: 'Home', icon: House, end: true },
  { to: '/world-cup', label: 'World Cup', icon: Trophy },
  { to: '/online', label: 'Online', icon: Globe },
  { to: '/practice', label: 'Practice', icon: Target },
  { to: '/settings', label: 'Settings', icon: Gear },
];

/** Frame for every menu screen: logo, tabs, notifications, profile, footer prompts. */
export function AppShell() {
  const session = useSession();
  const navigate = useNavigate();
  const { pathname } = useLocation();
  const [online, setOnline] = useState(navigator.onLine);

  useEffect(() => {
    const up = () => setOnline(true);
    const down = () => setOnline(false);
    window.addEventListener('online', up);
    window.addEventListener('offline', down);
    return () => {
      window.removeEventListener('online', up);
      window.removeEventListener('offline', down);
    };
  }, []);

  // Q/E and LB/RB flip between tabs.
  useEffect(() => {
    const onTab = (e: Event) => {
      const dir = (e as CustomEvent<number>).detail;
      const i = TABS.findIndex((t) => (t.end ? pathname === t.to : pathname.startsWith(t.to)));
      const next = TABS[(Math.max(i, 0) + dir + TABS.length) % TABS.length];
      navigate(next.to);
    };
    window.addEventListener('menu:tab', onTab);
    return () => window.removeEventListener('menu:tab', onTab);
  }, [pathname, navigate]);

  const profile = session.status === 'in' ? session.profile : null;

  return (
    <div className="app-bg dvh flex flex-col overflow-hidden">
      <MenuNav enabled />
      <a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:left-2 focus:top-2 focus:z-50 focus:rounded focus:bg-white focus:px-3 focus:py-2 focus:text-ink-900">
        Skip to content
      </a>

      <header className="safe-x relative z-20 flex shrink-0 items-center gap-4 border-b border-white/10 bg-ink-950/50 py-2 [@media(max-height:520px)]:py-1 backdrop-blur-md">
        <NavLink to="/" className="flex items-center gap-2 pr-2" aria-label="World Cup 2026 home">
          <Ball />
          <span className="t-display whitespace-nowrap text-2xl text-white">
            World Cup <span className="text-neon-400">2026</span>
          </span>
        </NavLink>

        <nav className="hidden flex-1 items-center justify-center gap-1 desk:flex" aria-label="Main">
          {TABS.map((t) => (
            <NavLink
              key={t.to}
              to={t.to}
              end={t.end}
              className={({ isActive }) =>
                `relative px-4 py-2 font-display text-lg font-bold uppercase italic tracking-wider transition-colors ${isActive ? 'text-white' : 'text-mist-400 hover:text-white'}`
              }
            >
              {({ isActive }) => (
                <>
                  {t.label}
                  {isActive && <span className="absolute inset-x-3 -bottom-[9px] h-[3px] bg-neon-400 shadow-[0_0_14px_#28e4ff]" />}
                </>
              )}
            </NavLink>
          ))}
        </nav>
        <div className="flex-1 desk:hidden" />

        <div className="flex items-center gap-3">
          {profile && <NotificationBell />}
          {profile ? (
            <NavLink to="/profile" className="flex items-center gap-2 rounded-full bg-white/10 py-1 pl-1 pr-4 ring-1 ring-white/20 hover:bg-white/20" aria-label="Your profile">
              <Avatar name={profile.displayName} online size={32} />
              <span className="hidden font-display text-base font-bold uppercase tracking-wide text-white sm:inline">{profile.displayName}</span>
            </NavLink>
          ) : session.status === 'loading' ? (
            <span className="skeleton h-9 w-28" />
          ) : (
            <NavLink to={session.status === 'needsProfile' ? '/welcome' : '/login'} className="btn btn-primary btn-sm">
              <span>{session.status === 'needsProfile' ? 'Finish sign-up' : 'Sign in'}</span>
            </NavLink>
          )}
        </div>
      </header>

      {!online && (
        <div role="alert" className="relative z-20 flex items-center justify-center gap-2 bg-hot-500/90 py-1.5 font-body text-sm font-semibold text-white">
          <WifiOff size={16} /> You are offline. Practice still works; online features will resume when you reconnect.
        </div>
      )}

      <main id="main" className="relative z-10 min-h-0 flex-1 overflow-y-auto overflow-x-hidden pb-16 [@media(max-height:520px)]:pb-12 desk:pb-0">
        <Outlet />
      </main>

      <HintBar />

      <nav className="safe-b fixed inset-x-0 bottom-0 z-30 flex border-t border-white/10 bg-ink-950/90 backdrop-blur-md desk:hidden" aria-label="Main">
        {TABS.map((t) => (
          <NavLink
            key={t.to}
            to={t.to}
            end={t.end}
            className={({ isActive }) =>
              `flex flex-1 flex-col items-center gap-0.5 py-2 [@media(max-height:520px)]:flex-row [@media(max-height:520px)]:justify-center [@media(max-height:520px)]:gap-2 [@media(max-height:520px)]:py-1 font-display text-[0.7rem] font-bold uppercase tracking-wider ${isActive ? 'text-neon-400' : 'text-mist-400'}`
            }
          >
            <t.icon size={20} />
            {t.label}
          </NavLink>
        ))}
      </nav>
    </div>
  );
}

function Ball() {
  return (
    <svg viewBox="0 0 32 32" width="30" height="30" aria-hidden="true">
      <circle cx="16" cy="16" r="14" fill="#fff" />
      <path d="M16 9l5 3.6-1.9 5.9h-6.2L11 12.6z" fill="#0b0933" />
      <path d="M16 9V4M21 12.6l4.8-1.6M19.1 18.5l3 4.2M12.9 18.5l-3 4.2M11 12.6L6.2 11" stroke="#0b0933" strokeWidth="1.6" fill="none" />
      <circle cx="16" cy="16" r="14" fill="none" stroke="#28e4ff" strokeWidth="2" />
    </svg>
  );
}
