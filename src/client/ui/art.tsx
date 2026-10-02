// Simple vector artwork for menu tiles (no image files to ship).

export function TrophyArt({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 200 240" className={className} aria-hidden="true">
      <defs>
        <linearGradient id="gold" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#fff3b0" />
          <stop offset="0.5" stopColor="#ffc83a" />
          <stop offset="1" stopColor="#c98a00" />
        </linearGradient>
      </defs>
      <ellipse cx="100" cy="222" rx="62" ry="10" fill="#000" opacity="0.25" />
      <path d="M62 24h76v50c0 30-17 52-38 58-21-6-38-28-38-58z" fill="url(#gold)" />
      <path d="M62 36H34c0 30 10 46 30 52M138 36h28c0 30-10 46-30 52" fill="none" stroke="url(#gold)" strokeWidth="9" strokeLinecap="round" />
      <path d="M92 132h16v36H92z" fill="url(#gold)" />
      <path d="M66 168h68l10 22H56z" fill="url(#gold)" />
      <rect x="52" y="190" width="96" height="22" rx="4" fill="#9a6a00" />
      <rect x="52" y="190" width="96" height="8" rx="3" fill="#ffd54f" opacity="0.7" />
      <path d="M78 40c-4 24-1 44 12 62" stroke="#fff" strokeOpacity="0.55" strokeWidth="6" strokeLinecap="round" fill="none" />
    </svg>
  );
}

export function VersusArt({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 240 200" className={className} aria-hidden="true">
      <defs>
        <linearGradient id="vsA" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#28e4ff" />
          <stop offset="1" stopColor="#2a4bd6" />
        </linearGradient>
        <linearGradient id="vsB" x1="1" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#ff6aa8" />
          <stop offset="1" stopColor="#b3156b" />
        </linearGradient>
      </defs>
      <path d="M20 30h90l-24 140H20z" fill="url(#vsA)" opacity="0.95" />
      <path d="M220 30h-90l24 140h66z" fill="url(#vsB)" opacity="0.95" />
      <path d="M62 62l22 0M52 92h34M44 122h28" stroke="#fff" strokeOpacity="0.35" strokeWidth="6" strokeLinecap="round" />
      <path d="M178 62h-22M188 92h-34M196 122h-28" stroke="#fff" strokeOpacity="0.35" strokeWidth="6" strokeLinecap="round" />
      <circle cx="120" cy="100" r="34" fill="#0b0933" stroke="#fff" strokeWidth="4" />
      <text x="120" y="112" textAnchor="middle" fontFamily="Barlow Condensed, sans-serif" fontWeight="800" fontStyle="italic" fontSize="34" fill="#fff">VS</text>
    </svg>
  );
}

export function PracticeArt({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 240 200" className={className} aria-hidden="true">
      <rect x="20" y="40" width="200" height="130" rx="6" fill="none" stroke="#fff" strokeOpacity="0.5" strokeWidth="3" />
      <rect x="150" y="68" width="70" height="74" fill="none" stroke="#fff" strokeOpacity="0.5" strokeWidth="3" />
      <circle cx="20" cy="105" r="26" fill="none" stroke="#fff" strokeOpacity="0.4" strokeWidth="3" />
      <path d="M60 150C90 90 130 100 188 96" stroke="#28e4ff" strokeWidth="4" strokeDasharray="2 10" strokeLinecap="round" fill="none" />
      <circle cx="60" cy="150" r="14" fill="#fff" />
      <path d="M60 143l6 4-2 7h-8l-2-7z" fill="#0b0933" />
      <g stroke="#ff6aa8" strokeWidth="4" fill="none">
        <circle cx="196" cy="96" r="12" />
        <circle cx="196" cy="96" r="5" />
      </g>
    </svg>
  );
}

export function ProfileArt({ className = '' }: { className?: string }) {
  return (
    <svg viewBox="0 0 240 200" className={className} aria-hidden="true">
      <defs>
        <linearGradient id="card" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#ffe28a" />
          <stop offset="1" stopColor="#c98a00" />
        </linearGradient>
      </defs>
      <path d="M70 18h100l22 22v132H48V40z" fill="url(#card)" />
      <path d="M70 30h100l12 12v120H58V42z" fill="none" stroke="#fff" strokeOpacity="0.55" strokeWidth="2" />
      <circle cx="120" cy="82" r="22" fill="#0b0933" opacity="0.85" />
      <path d="M76 150c4-26 22-38 44-38s40 12 44 38z" fill="#0b0933" opacity="0.85" />
      <text x="120" y="160" textAnchor="middle" fontFamily="Barlow Condensed, sans-serif" fontWeight="800" fontSize="20" fill="#0b0933">W · D · L</text>
    </svg>
  );
}
