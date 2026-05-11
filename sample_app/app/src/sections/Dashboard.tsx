import { useEffect, useState } from 'react';
import type { IntakeRecord } from '@/types';
import { caffeineAtTime } from '@/hooks/useCaffeineEngine';
import { useCaffeineEngine } from '@/hooks/useCaffeineEngine';
import { Card, CardContent } from '@/components/ui/card';
import { Progress } from '@/components/ui/progress';

interface DashboardProps {
  engine: ReturnType<typeof useCaffeineEngine>;
}

function CircularGauge({ value, max, label, color }: { value: number; max: number; label: string; color: string }) {
  const pct = Math.min(100, (value / max) * 100);
  const r = 80;
  const c = 2 * Math.PI * r;
  const dash = c * (pct / 100);

  let statusColor = color;
  if (pct > 80) statusColor = '#C0392B';
  else if (pct > 60) statusColor = '#E67E22';
  else if (pct > 40) statusColor = '#D4A574';

  return (
    <div className="flex flex-col items-center">
      <div className="relative w-[180px] h-[180px]">
        <svg viewBox="0 0 200 200" className="w-full h-full -rotate-90">
          <circle cx="100" cy="100" r={r} fill="none" stroke="#E8DCC8" strokeWidth="14" />
          <circle
            cx="100" cy="100" r={r}
            fill="none" stroke={statusColor} strokeWidth="14"
            strokeDasharray={`${dash} ${c - dash}`}
            strokeLinecap="round"
            className="transition-all duration-700"
          />
        </svg>
        <div className="absolute inset-0 flex flex-col items-center justify-center">
          <span className="text-3xl font-bold text-[#3C2415]">{Math.round(value)}</span>
          <span className="text-xs text-[#8B7355]">mg</span>
        </div>
      </div>
      <p className="text-sm font-medium text-[#6F4E37] mt-2">{label}</p>
      <p className="text-xs text-[#A89080]">上限 {max}mg</p>
    </div>
  );
}

function MiniTimeline({ records, halfLife }: { records: IntakeRecord[]; halfLife: number }) {
  const now = Date.now();
  const points: { t: number; val: number }[] = [];
  for (let i = 0; i <= 96; i++) {
    const t = now - 8 * 3600000 + i * 15 * 60 * 1000;
    points.push({ t, val: caffeineAtTime(records, t, halfLife) });
  }
  const maxVal = Math.max(...points.map(p => p.val), 1);
  const w = 380;
  const h = 80;
  const nowIdx = points.findIndex(p => p.t >= now);

  const pathD = points.map((p, i) => {
    const x = (i / (points.length - 1)) * w;
    const y = h - (p.val / maxVal) * h * 0.85 - 5;
    return `${i === 0 ? 'M' : 'L'}${x},${y}`;
  }).join(' ');

  return (
    <div className="mt-4">
      <p className="text-xs text-[#8B7355] mb-1">过去8h → 未来16h</p>
      <svg viewBox={`0 0 ${w} ${h}`} className="w-full h-[80px]">
        <defs>
          <linearGradient id="areaFill" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="#6F4E37" stopOpacity="0.3" />
            <stop offset="100%" stopColor="#6F4E37" stopOpacity="0.02" />
          </linearGradient>
        </defs>
        <path d={pathD + ` L${w},${h} L0,${h} Z`} fill="url(#areaFill)" />
        <path d={pathD} fill="none" stroke="#6F4E37" strokeWidth="2" />
        {nowIdx > 0 && (
          <line x1={(nowIdx/(points.length-1))*w} y1="0" x2={(nowIdx/(points.length-1))*w} y2={h} stroke="#C0392B" strokeWidth="1" strokeDasharray="4 2" />
        )}
        {nowIdx > 0 && (
          <text x={(nowIdx/(points.length-1))*w + 4} y="12" fontSize="10" fill="#C0392B">现在</text>
        )}
      </svg>
    </div>
  );
}

export function Dashboard({ engine }: DashboardProps) {
  const [greeting, setGreeting] = useState('');

  useEffect(() => {
    const h = new Date().getHours();
    if (h < 6) setGreeting('夜深了');
    else if (h < 12) setGreeting('早上好');
    else if (h < 18) setGreeting('下午好');
    else setGreeting('晚上好');
  }, []);

  const budget = engine.profile.isPregnant ? 200 : engine.profile.dailyBudget;
  const safeSleep = new Date(engine.safeSleepTime);
  const fullClear = new Date(engine.fullClearTime);
  const budgetPercent = Math.min(100, (engine.todayTotal / budget) * 100);

  const adviceColors = {
    safe: { bg: 'bg-emerald-50', border: 'border-emerald-200', text: 'text-emerald-700', icon: '✅' },
    warn: { bg: 'bg-amber-50', border: 'border-amber-200', text: 'text-amber-700', icon: '⚠️' },
    danger: { bg: 'bg-red-50', border: 'border-red-200', text: 'text-red-700', icon: '🚫' },
  };
  const ac = adviceColors[engine.advice.type];

  const to12h = (d: Date) => d.toLocaleTimeString('zh-CN', { hour: 'numeric', minute: '2-digit', hour12: true });

  return (
    <div className="px-4 pt-6 pb-8 space-y-5">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-[#8B7355]">{greeting}</p>
          <h1 className="text-2xl font-bold text-[#3C2415]">HalfCaff</h1>
        </div>
        <div className="flex items-center gap-1.5 bg-white rounded-full px-3 py-1.5 shadow-sm">
          <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
          <span className="text-xs text-[#6F4E37] font-medium">代谢中</span>
        </div>
      </div>

      {/* Main Gauge */}
      <div className="flex justify-center">
        <CircularGauge
          value={engine.currentAmount}
          max={budget}
          label="体内咖啡因"
          color="#6F4E37"
        />
      </div>

      {/* Stats Row */}
      <div className="grid grid-cols-3 gap-3">
        <Card className="bg-white border-[#E8DCC8] shadow-sm">
          <CardContent className="p-3 text-center">
            <p className="text-xs text-[#8B7355]">今日累计</p>
            <p className="text-lg font-bold text-[#3C2415]">{Math.round(engine.todayTotal)}<span className="text-xs font-normal text-[#A89080]">mg</span></p>
          </CardContent>
        </Card>
        <Card className="bg-white border-[#E8DCC8] shadow-sm">
          <CardContent className="p-3 text-center">
            <p className="text-xs text-[#8B7355]">半衰期</p>
            <p className="text-lg font-bold text-[#3C2415]">{engine.halfLife}<span className="text-xs font-normal text-[#A89080]">h</span></p>
          </CardContent>
        </Card>
        <Card className="bg-white border-[#E8DCC8] shadow-sm">
          <CardContent className="p-3 text-center">
            <p className="text-xs text-[#8B7355]">预算余额</p>
            <p className="text-lg font-bold text-[#3C2415]">{Math.max(0, budget - engine.todayTotal)}<span className="text-xs font-normal text-[#A89080]">mg</span></p>
          </CardContent>
        </Card>
      </div>

      {/* Budget Bar */}
      <div>
        <div className="flex justify-between text-xs mb-1">
          <span className="text-[#8B7355]">日预算进度</span>
          <span className="text-[#6F4E37] font-medium">{Math.round(engine.todayTotal)} / {budget}mg</span>
        </div>
        <Progress value={budgetPercent} className="h-2.5 bg-[#E8DCC8]" />
      </div>

      {/* Smart Advice */}
      <div className={`${ac.bg} ${ac.border} border rounded-xl p-4 flex gap-3 items-start`}>
        <span className="text-xl mt-0.5">{ac.icon}</span>
        <div>
          <p className={`${ac.text} text-sm font-medium`}>{engine.advice.text}</p>
          <p className="text-xs text-[#8B7355] mt-1">
            安全入睡: {to12h(safeSleep)} · 完全代谢: {to12h(fullClear)}
          </p>
        </div>
      </div>

      {/* Mini Timeline */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4">
          <div className="flex items-center justify-between mb-2">
            <h3 className="text-sm font-semibold text-[#6F4E37]">咖啡因曲线</h3>
            <span className="text-xs text-[#A89080]">点击"时间线"查看完整版</span>
          </div>
          <MiniTimeline records={engine.records} halfLife={engine.halfLife} />
        </CardContent>
      </Card>

      {/* Recent Intakes */}
      {engine.records.length > 0 && (
        <div>
          <h3 className="text-sm font-semibold text-[#6F4E37] mb-3">今日摄入记录</h3>
          <div className="space-y-2">
            {[...engine.records].reverse().slice(0, 6).map(r => {
              const hoursAgo = ((Date.now() - r.timestamp) / 3600000).toFixed(1);
              return (
                <div key={r.id} className="flex items-center gap-3 bg-white rounded-xl p-3 shadow-sm border border-[#E8DCC8]/50">
                  <span className="text-2xl">{r.icon}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-[#3C2415] truncate">{r.drinkName}</p>
                    <p className="text-xs text-[#A89080]">{hoursAgo}小时前 · 剩余 {Math.round(r.caffeineAmount * Math.pow(0.5, parseFloat(hoursAgo)/engine.halfLife))}mg</p>
                  </div>
                  <span className="text-sm font-bold text-[#6F4E37]">+{r.caffeineAmount}mg</span>
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
