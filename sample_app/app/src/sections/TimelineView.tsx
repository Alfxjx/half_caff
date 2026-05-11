import { useMemo } from 'react';
import { useCaffeineEngine } from '@/hooks/useCaffeineEngine';
import { Card, CardContent } from '@/components/ui/card';
import { Slider } from '@/components/ui/slider';
import { useState } from 'react';

interface TimelineViewProps {
  engine: ReturnType<typeof useCaffeineEngine>;
}

export function TimelineView({ engine }: TimelineViewProps) {
  const [previewDose, setPreviewDose] = useState(0);
  const [selectedIdx, setSelectedIdx] = useState<number | null>(null);

  const { timeline, records, halfLife } = engine;
  const maxVal = useMemo(() => Math.max(...timeline.map(p => p.amount), 1), [timeline]);

  const budget = engine.profile.isPregnant ? 200 : 400;
  const now = Date.now();

  // SVG dimensions
  const W = 380;
  const H = 200;
  const PAD = { top: 15, right: 10, bottom: 30, left: 10 };
  const gW = W - PAD.left - PAD.right;
  const gH = H - PAD.top - PAD.bottom;

  const previewTimeline = useMemo(() => {
    if (previewDose <= 0) return [];
    const mockRecord = { id: 'preview', timestamp: now, drinkName: '假设摄入', caffeineAmount: previewDose, icon: '', color: '' };
    const pts = [];
    for (let m = 0; m <= 24 * 4; m++) {
      const t = now + m * 15 * 60 * 1000;
      let amount = 0;
      for (const r of records) {
        const h = (t - r.timestamp) / 3600000;
        if (h >= 0) amount += r.caffeineAmount * Math.pow(0.5, h / halfLife);
      }
      const h = (t - mockRecord.timestamp) / 3600000;
      if (h >= 0) amount += mockRecord.caffeineAmount * Math.pow(0.5, h / halfLife);
      pts.push({ time: t, amount });
    }
    return pts;
  }, [previewDose, records, halfLife]);

  const toX = (idx: number) => PAD.left + (idx / (timeline.length - 1)) * gW;
  const toY = (val: number) => PAD.top + (1 - val / maxVal) * gH * 0.9;

  const mainPath = timeline.map((p, i) => `${i === 0 ? 'M' : 'L'}${toX(i)},${toY(p.amount)}`).join(' ');
  const areaPath = mainPath + ` L${toX(timeline.length - 1)},${H - PAD.bottom} L${toX(0)},${H - PAD.bottom} Z`;
  const previewPath = previewTimeline.length > 0
    ? previewTimeline.map((p, i) => `${i === 0 ? 'M' : 'L'}${toX(i)},${toY(p.amount)}`).join(' ')
    : '';

  // Find now index
  const nowIdx = timeline.findIndex(p => p.time >= now);
  const selectedPoint = selectedIdx !== null ? timeline[selectedIdx] : null;

  // Threshold lines
  const y400 = toY(400);
  const y200 = toY(200);
  const y50 = toY(50);

  // Time labels every 4 hours
  const timeLabels = [];
  for (let i = 0; i < timeline.length; i += 16) {
    timeLabels.push({ idx: i, label: timeline[i].label });
  }

  // Sleep threshold zone
  const safeSleepIdx = timeline.findIndex(p => p.amount < 50);

  return (
    <div className="px-4 pt-6 pb-8 space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-[#3C2415]">24小时时间线</h1>
        <p className="text-sm text-[#8B7355]">体内咖啡因浓度预测</p>
      </div>

      {/* Main Chart */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm overflow-hidden">
        <CardContent className="p-3">
          <svg viewBox={`0 0 ${W} ${H}`} className="w-full" style={{ maxHeight: '220px' }}>
            <defs>
              <linearGradient id="mainGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#6F4E37" stopOpacity="0.35" />
                <stop offset="100%" stopColor="#6F4E37" stopOpacity="0.02" />
              </linearGradient>
              <linearGradient id="previewGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#6F4E37" stopOpacity="0.1" />
                <stop offset="100%" stopColor="#6F4E37" stopOpacity="0.01" />
              </linearGradient>
            </defs>

            {/* Threshold zones */}
            {y400 > PAD.top && (
              <rect x={PAD.left} y={PAD.top} width={gW} height={Math.max(0, y400 - PAD.top)} fill="#C0392B" opacity="0.06" />
            )}
            {y200 > PAD.top && y400 > PAD.top && (
              <rect x={PAD.left} y={y400} width={gW} height={Math.max(0, y200 - y400)} fill="#E67E22" opacity="0.06" />
            )}
            {safeSleepIdx > 0 && (
              <rect x={toX(safeSleepIdx)} y={PAD.top} width={toX(timeline.length-1) - toX(safeSleepIdx)} height={gH * 0.9 + 5} fill="#27AE60" opacity="0.06" rx="4" />
            )}

            {/* Threshold lines */}
            <line x1={PAD.left} y1={y400} x2={PAD.left + gW} y2={y400} stroke="#C0392B" strokeWidth="0.5" strokeDasharray="3 3" opacity="0.4" />
            <text x={PAD.left + gW + 2} y={y400 + 3} fontSize="8" fill="#C0392B" opacity="0.6">400</text>
            <line x1={PAD.left} y1={y50} x2={PAD.left + gW} y2={y50} stroke="#27AE60" strokeWidth="0.5" strokeDasharray="3 3" opacity="0.4" />
            <text x={PAD.left + gW + 2} y={y50 + 3} fontSize="8" fill="#27AE60" opacity="0.6">50</text>

            {/* Now line */}
            {nowIdx > 0 && (
              <>
                <line x1={toX(nowIdx)} y1={PAD.top} x2={toX(nowIdx)} y2={H - PAD.bottom} stroke="#C0392B" strokeWidth="1.5" strokeDasharray="5 3" />
                <rect x={toX(nowIdx) - 14} y={PAD.top - 2} width="28" height="14" rx="4" fill="#C0392B" />
                <text x={toX(nowIdx)} y={PAD.top + 8} fontSize="8" fill="white" textAnchor="middle" fontWeight="bold">现在</text>
              </>
            )}

            {/* Main area */}
            <path d={areaPath} fill="url(#mainGrad)" />
            <path d={mainPath} fill="none" stroke="#6F4E37" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" />

            {/* Preview line */}
            {previewPath && (
              <>
                <path d={previewPath + ` L${toX(previewTimeline.length - 1)},${H - PAD.bottom} L${toX(0)},${H - PAD.bottom} Z`} fill="url(#previewGrad)" />
                <path d={previewPath} fill="none" stroke="#6F4E37" strokeWidth="2" strokeDasharray="6 4" opacity="0.6" strokeLinecap="round" />
              </>
            )}

            {/* Selection dot */}
            {selectedIdx !== null && (
              <>
                <line x1={toX(selectedIdx)} y1={PAD.top} x2={toX(selectedIdx)} y2={H - PAD.bottom} stroke="#6F4E37" strokeWidth="0.5" strokeDasharray="2 2" opacity="0.5" />
                <circle cx={toX(selectedIdx)} cy={toY(timeline[selectedIdx].amount)} r="5" fill="#6F4E37" stroke="white" strokeWidth="2" />
              </>
            )}

            {/* Time labels */}
            {timeLabels.map((tl, i) => (
              <text key={i} x={toX(tl.idx)} y={H - 6} fontSize="9" fill="#A89080" textAnchor="middle">{tl.label}</text>
            ))}

            {/* Interactive overlay */}
            {timeline.map((_, i) => (
              <rect key={i} x={toX(i) - toX(1)/2} y={PAD.top} width={toX(1)} height={gH * 0.9 + 5} fill="transparent"
                onClick={() => setSelectedIdx(i)} onMouseEnter={() => setSelectedIdx(i)} />
            ))}
          </svg>

          {/* Legend */}
          <div className="flex justify-center gap-4 mt-1">
            <span className="flex items-center gap-1 text-[10px] text-[#8B7355]"><span className="w-2 h-2 rounded-full bg-[#6F4E37]" />预测曲线</span>
            {previewDose > 0 && <span className="flex items-center gap-1 text-[10px] text-[#8B7355]"><span className="w-3 h-0.5 bg-[#6F4E37] border-dashed border" />假设摄入</span>}
            <span className="flex items-center gap-1 text-[10px] text-[#27AE60]"><span className="w-2 h-2 rounded-full bg-[#27AE60] opacity-40" />安全区</span>
            <span className="flex items-center gap-1 text-[10px] text-[#C0392B]"><span className="w-2 h-2 rounded-full bg-[#C0392B] opacity-40" />危险区</span>
          </div>

          {/* Selected point info */}
          {selectedPoint && (
            <div className="mt-2 bg-[#F5EDE0] rounded-lg p-2 text-center">
              <span className="text-xs text-[#6F4E37]">{selectedPoint.label} · </span>
              <span className="text-sm font-bold text-[#3C2415]">{Math.round(selectedPoint.amount)}mg</span>
              {selectedPoint.amount > budget && <span className="text-[10px] text-red-500 ml-1">⚠️ 超预算</span>}
              {selectedPoint.amount < 50 && <span className="text-[10px] text-emerald-600 ml-1">✅ 安全入睡</span>}
            </div>
          )}
        </CardContent>
      </Card>

      {/* What-if simulator */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4 space-y-3">
          <h3 className="text-sm font-semibold text-[#6F4E37]">☕ 如果我现在再喝一杯...</h3>
          <div className="flex items-center gap-3">
            <span className="text-xs text-[#8B7355] w-10">{previewDose}mg</span>
            <Slider value={[previewDose]} onValueChange={v => setPreviewDose(v[0])} max={300} step={10} className="flex-1" />
          </div>
          {previewDose > 0 && (
            <div className="text-xs space-y-1 text-[#6F4E37]">
              <p>当前体内 + 这杯 = <strong>{Math.round(engine.currentAmount + previewDose)}mg</strong>（峰值）</p>
              {(() => {
                const newPeak = engine.currentAmount + previewDose;
                if (newPeak > budget) return <p className="text-red-500">⚠️ 将超过日安全上限 ({budget}mg)</p>;
                if (newPeak > 200) return <p className="text-amber-600">⚠️ 峰值较高，可能影响晚上入睡</p>;
                return <p className="text-emerald-600">✅ 在可接受范围内</p>;
              })()}
              <p className="text-[#8B7355]">曲线图中虚线展示了摄入后的预测变化</p>
            </div>
          )}
          {previewDose === 0 && <p className="text-xs text-[#A89080]">拖动滑块预览不同剂量的影响</p>}
        </CardContent>
      </Card>

      {/* Key moments */}
      <div className="space-y-2">
        <h3 className="text-sm font-semibold text-[#6F4E37]">⏰ 关键时间节点</h3>
        <div className="grid grid-cols-2 gap-2">
          <div className="bg-white rounded-xl p-3 border border-[#E8DCC8] shadow-sm">
            <p className="text-xs text-[#8B7355]">咖啡因峰值</p>
            <p className="text-lg font-bold text-[#3C2415]">
              {Math.round(Math.max(...timeline.map(p => p.amount)))}mg
            </p>
            <p className="text-xs text-[#A89080]">
              @{timeline.reduce((a, b) => a.amount > b.amount ? a : b).label}
            </p>
          </div>
          <div className="bg-emerald-50 rounded-xl p-3 border border-emerald-100 shadow-sm">
            <p className="text-xs text-emerald-600">安全入睡</p>
            <p className="text-lg font-bold text-emerald-800">
              {new Date(engine.safeSleepTime).toLocaleTimeString('zh-CN', { hour: 'numeric', minute: '2-digit', hour12: true })}
            </p>
            <p className="text-xs text-emerald-500">体内 &lt; 50mg</p>
          </div>
          <div className="bg-white rounded-xl p-3 border border-[#E8DCC8] shadow-sm">
            <p className="text-xs text-[#8B7355]">完全代谢</p>
            <p className="text-lg font-bold text-[#3C2415]">
              {new Date(engine.fullClearTime).toLocaleTimeString('zh-CN', { hour: 'numeric', minute: '2-digit', hour12: true })}
            </p>
            <p className="text-xs text-[#A89080]">体内 &lt; 5mg</p>
          </div>
          <div className="bg-white rounded-xl p-3 border border-[#E8DCC8] shadow-sm">
            <p className="text-xs text-[#8B7355]">半衰期</p>
            <p className="text-lg font-bold text-[#3C2415]">{halfLife}h</p>
            <p className="text-xs text-[#A89080]">个人代谢速度</p>
          </div>
        </div>
      </div>
    </div>
  );
}
