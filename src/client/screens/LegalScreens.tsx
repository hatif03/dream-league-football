import type { ReactNode } from 'react';
import { Link } from 'react-router-dom';
import { LinkBtn } from '@/client/ui/controls';

function Doc({ title, children }: { title: string; children: ReactNode }) {
  return (
    <div className="mx-auto max-w-3xl px-4 py-8">
      <div className="glass p-6 md:p-8 animate-screen-in">
        <h1 className="t-display mb-5 text-4xl text-white md:text-5xl">{title}</h1>
        <div className="space-y-6 font-body leading-relaxed text-mist-200">{children}</div>
      </div>
    </div>
  );
}
const H = ({ children }: { children: ReactNode }) => <h2 className="t-display mb-2 text-2xl text-neon-300">{children}</h2>;

export function TermsScreen() {
  return (
    <Doc title="Terms">
      <section>
        <H>Using the game</H>
        <p>Dream League Football is a free browser game. Play fair: no cheating, no abuse in chat, no impersonation. We may suspend accounts that break these rules.</p>
      </section>
      <section>
        <H>Your account</H>
        <p>You are responsible for your password. Pick a display name that is not offensive. We may remove names that are.</p>
      </section>
      <section>
        <H>Results</H>
        <p>A friend match is recorded only when both players report the same result. Matches that end early, or where the results disagree, are not counted for anyone.</p>
      </section>
      <section>
        <H>No warranty</H>
        <p>The game is provided as is. It is a fan-made arcade game and is not affiliated with FIFA or any national association.</p>
      </section>
      <p className="text-sm text-mist-400">See also the <Link to="/privacy" className="text-neon-400 underline">Privacy notice</Link>.</p>
    </Doc>
  );
}

export function PrivacyScreen() {
  return (
    <Doc title="Privacy">
      <section>
        <H>What we store</H>
        <ul className="list-disc space-y-1 pl-5">
          <li>Your email address and a hashed password, to sign you in.</li>
          <li>Your display name (visible to other players) and favourite nation.</li>
          <li>Your World Cup runs: the nation, every fixture and score.</li>
          <li>Friend matches: who played, nations, score, how it ended, and match numbers such as possession and shots.</li>
          <li>Friends, blocks, invites, and the chat lines you send in a room.</li>
          <li>Reports you file about other players, with the match they refer to.</li>
          <li>When your app last checked in, so friends can see you are online.</li>
        </ul>
      </section>
      <section>
        <H>What we do not store</H>
        <p>Practice matches are not recorded. Your key, controller and touch settings stay in your browser. During a direct match the game traffic goes between the two browsers; when that is not possible it passes through our relay without being kept.</p>
      </section>
      <section>
        <H>Your choices</H>
        <p>Delete your account on your profile page. That removes your sign-in, display name, World Cup runs, friends, blocks and chat lines. Friend matches you played stay in the other player's history, where your name shows as "Removed player". You can block any player and report one from the full-time screen.</p>
      </section>
      <section>
        <H>Where it lives</H>
        <p>Data is held in a PostgreSQL database on Serverpod Cloud (Europe). Sign-in emails are sent through Serverpod Cloud's email service. Flags are bundled with the game; fonts load from Google Fonts.</p>
      </section>
    </Doc>
  );
}

export function NotFoundScreen() {
  return (
    <div className="mx-auto flex min-h-full max-w-md flex-col items-center justify-center px-4 py-16 text-center">
      <div className="t-display text-[9rem] leading-none text-white/90">404</div>
      <p className="mb-6 font-body text-lg text-mist-300">Offside! There is nothing on this page.</p>
      <LinkBtn to="/" variant="primary" size="lg">Back to the pitch</LinkBtn>
    </div>
  );
}
