import { useLastDevice } from '@/client/game/inputDevices';
import { SettingsPanels } from '@/client/ui/SettingsPanels';
import { InstallCard } from '@/client/ui/install';

export default function SettingsScreen() {
  const device = useLastDevice();
  return (
    <div className="mx-auto max-w-4xl px-4 py-5 md:py-8">
      <div className="mb-4">
        <div className="t-label">Customise</div>
        <h1 className="t-display text-4xl text-white md:text-6xl">Settings</h1>
      </div>
      <InstallCard />
      <div className="glass p-4 md:p-6 animate-screen-in">
        <SettingsPanels initial={device === 'touch' ? 'touch' : device === 'controller' ? 'controller' : 'keyboard'} />
      </div>
      <p className="mt-4 text-center font-body text-xs text-mist-500">Settings are saved in this browser only.</p>
    </div>
  );
}
