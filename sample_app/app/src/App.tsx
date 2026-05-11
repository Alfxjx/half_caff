import { useState } from 'react';
import { useCaffeineEngine } from '@/hooks/useCaffeineEngine';
import { Dashboard } from '@/sections/Dashboard';
import { TimelineView } from '@/sections/TimelineView';
import { AddRecord } from '@/sections/AddRecord';
import { Explore } from '@/sections/Explore';
import { Profile } from '@/sections/Profile';
import { Toaster } from '@/components/ui/sonner';
import { toast } from 'sonner';
import type { TabId } from '@/types';
import './App.css';

function App() {
  const [activeTab, setActiveTab] = useState<TabId>('dashboard');
  const engine = useCaffeineEngine();

  const handleAdd = (drink: { name: string; caffeineMg: number; icon: string; color: string }) => {
    engine.addRecord({
      id: Date.now().toString(),
      name: drink.name,
      caffeineMg: drink.caffeineMg,
      icon: drink.icon,
      color: drink.color,
      volumeMl: 0,
      category: 'coffee',
    });
    toast.success(`已记录 ${drink.name} (+${drink.caffeineMg}mg)`, {
      description: `体内咖啡因: ${Math.round(engine.currentAmount + drink.caffeineMg)}mg`,
    });
    setActiveTab('dashboard');
  };

  const handleAddCustom = (name: string, amount: number) => {
    engine.addCustomRecord(name, amount);
    toast.success(`已记录 ${name} (+${amount}mg)`, {
      description: `体内咖啡因: ${Math.round(engine.currentAmount + amount)}mg`,
    });
    setActiveTab('dashboard');
  };

  const tabs: { id: TabId; label: string; icon: string }[] = [
    { id: 'dashboard', label: '仪表盘', icon: '◉' },
    { id: 'timeline', label: '时间线', icon: '◈' },
    { id: 'add', label: '记录', icon: '⊕' },
    { id: 'explore', label: '探索', icon: '◇' },
    { id: 'profile', label: '档案', icon: '○' },
  ];

  return (
    <div className="min-h-screen bg-[#FAF6F1] flex justify-center">
      <div className="w-full max-w-[430px] relative min-h-screen bg-[#FAF6F1] shadow-2xl">
        {/* Main Content */}
        <main className="pb-20">
          {activeTab === 'dashboard' && <Dashboard engine={engine} />}
          {activeTab === 'timeline' && <TimelineView engine={engine} />}
          {activeTab === 'add' && <AddRecord onAdd={handleAdd} onAddCustom={handleAddCustom} currentAmount={engine.currentAmount} profile={engine.profile} />}
          {activeTab === 'explore' && <Explore />}
          {activeTab === 'profile' && <Profile engine={engine} />}
        </main>

        {/* Bottom Navigation */}
        <nav className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] bg-white/95 backdrop-blur-md border-t border-[#E8DCC8] z-50">
          <div className="flex justify-around py-2">
            {tabs.map(tab => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id)}
                className={`flex flex-col items-center gap-0.5 px-4 py-1.5 rounded-xl transition-all ${
                  activeTab === tab.id
                    ? 'text-[#6F4E37]'
                    : 'text-[#A89080] hover:text-[#6F4E37]'
                }`}
              >
                <span className={`text-xl ${activeTab === tab.id ? 'scale-110' : ''} transition-transform`}>
                  {tab.icon}
                </span>
                <span className="text-[10px] font-medium">{tab.label}</span>
                {activeTab === tab.id && (
                  <span className="w-5 h-0.5 bg-[#6F4E37] rounded-full mt-0.5" />
                )}
              </button>
            ))}
          </div>
        </nav>
        <Toaster position="top-center" />
      </div>
    </div>
  );
}

export default App;
