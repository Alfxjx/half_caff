import { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';

type SectionId = 'drinks' | 'metabolism' | 'formula' | 'factors';

export function Explore() {
  const [activeSection, setActiveSection] = useState<SectionId>('drinks');

  const sections: { id: SectionId; label: string; icon: string }[] = [
    { id: 'drinks', label: '咖啡因百科', icon: '☕' },
    { id: 'metabolism', label: '代谢流程', icon: '🔄' },
    { id: 'formula', label: '计算公式', icon: '📐' },
    { id: 'factors', label: '影响因素', icon: '⚡' },
  ];

  return (
    <div className="px-4 pt-6 pb-8 space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-[#3C2415]">探索</h1>
        <p className="text-sm text-[#8B7355]">咖啡因科学与数据</p>
      </div>

      {/* Section Tabs */}
      <div className="flex gap-2 overflow-x-auto pb-1">
        {sections.map(sec => (
          <button
            key={sec.id}
            onClick={() => setActiveSection(sec.id)}
            className={`flex items-center gap-1 px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-all ${
              activeSection === sec.id
                ? 'bg-[#6F4E37] text-white'
                : 'bg-white text-[#6F4E37] border border-[#E8DCC8]'
            }`}
          >
            <span>{sec.icon}</span>
            {sec.label}
          </button>
        ))}
      </div>

      {/* Drinks Encyclopedia */}
      {activeSection === 'drinks' && (
        <div className="space-y-3">
          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">☕ 常见饮品咖啡因含量</h3>
              <div className="space-y-2 text-sm">
                {[
                  { name: '意式浓缩 (Double)', mg: '130', icon: '☕', bar: 65 },
                  { name: '美式咖啡 (Grande)', mg: '225', icon: '☕', bar: 100 },
                  { name: '拿铁 (Grande)', mg: '150', icon: '🥛', bar: 67 },
                  { name: '冷萃咖啡', mg: '200', icon: '🧊', bar: 89 },
                  { name: '手冲咖啡', mg: '110', icon: '☕', bar: 49 },
                  { name: '摩卡壶', mg: '85', icon: '☕', bar: 38 },
                  { name: '速溶咖啡', mg: '70', icon: '☕', bar: 31 },
                  { name: '低因咖啡', mg: '5', icon: '☕', bar: 2 },
                  { name: '红茶', mg: '45', icon: '🫖', bar: 20 },
                  { name: '绿茶', mg: '25', icon: '🫖', bar: 11 },
                  { name: '抹茶', mg: '70', icon: '🍵', bar: 31 },
                  { name: '可口可乐', mg: '34', icon: '🥤', bar: 15 },
                  { name: '红牛', mg: '80', icon: '🥫', bar: 36 },
                  { name: 'Monster', mg: '160', icon: '🥫', bar: 71 },
                  { name: '黑巧克力 (30g)', mg: '25', icon: '🍫', bar: 11 },
                  { name: '咖啡因片', mg: '200', icon: '💊', bar: 89 },
                ].map((item, i) => (
                  <div key={i} className="flex items-center gap-2">
                    <span className="text-base w-6">{item.icon}</span>
                    <span className="text-[#3C2415] w-28 text-xs truncate">{item.name}</span>
                    <div className="flex-1 h-3 bg-[#E8DCC8] rounded-full overflow-hidden">
                      <div className="h-full rounded-full bg-[#6F4E37] transition-all" style={{ width: `${item.bar}%` }} />
                    </div>
                    <span className="text-xs font-bold text-[#6F4E37] w-10 text-right">{item.mg}mg</span>
                  </div>
                ))}
              </div>
              <p className="text-[10px] text-[#A89080] mt-3">* 基于 240ml 标准杯量估算，实际含量因品牌而异</p>
            </CardContent>
          </Card>

          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">🌱 咖啡豆种对比</h3>
              <div className="grid grid-cols-3 gap-3 text-center">
                {[
                  { name: '罗布斯塔', pct: '2.2-2.7%', color: '#4E342E', note: '咖啡因最高' },
                  { name: '阿拉比卡', pct: '1.2-1.5%', color: '#6F4E37', note: '精品主流' },
                  { name: '脱因处理', pct: '<0.1%', color: '#BCAAA4', note: '极低含量' },
                ].map((bean, i) => (
                  <div key={i} className="rounded-lg p-3" style={{ backgroundColor: bean.color + '12' }}>
                    <div className="w-6 h-6 rounded-full mx-auto mb-1" style={{ backgroundColor: bean.color }} />
                    <p className="text-xs font-semibold text-[#3C2415]">{bean.name}</p>
                    <p className="text-sm font-bold" style={{ color: bean.color }}>{bean.pct}</p>
                    <p className="text-[10px] text-[#8B7355]">{bean.note}</p>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Metabolism Flow */}
      {activeSection === 'metabolism' && (
        <div className="space-y-3">
          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">🔄 体内代谢流程</h3>
              <div className="space-y-3">
                {[
                  { step: '1', title: '口服摄入', desc: '咖啡因在30-45分钟内几乎完全从胃肠道吸收入血', icon: '👄', color: '#8B6914' },
                  { step: '2', title: '血液循环', desc: '分布于全身，血浆蛋白结合率仅10-30%，自由扩散', icon: '🩸', color: '#C0392B' },
                  { step: '3', title: '肝脏代谢', desc: 'CYP1A2 酶系催化 95% 的去甲基化反应', icon: '🫁', color: '#27AE60' },
                  { step: '4', title: '产物排泄', desc: '代谢产物转化为尿酸，经肾脏排出体外', icon: '🚰', color: '#2980B9' },
                ].map((s, i) => (
                  <div key={i} className="flex gap-3 items-start">
                    <div className="flex flex-col items-center">
                      <div className="w-10 h-10 rounded-full flex items-center justify-center text-lg" style={{ backgroundColor: s.color + '20' }}>
                        {s.icon}
                      </div>
                      {i < 3 && <div className="w-0.5 h-6 bg-[#E8DCC8]" />}
                    </div>
                    <div className="flex-1 pb-2">
                      <p className="text-sm font-semibold text-[#3C2415]">{s.title}</p>
                      <p className="text-xs text-[#8B7355] leading-relaxed">{s.desc}</p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">🧬 代谢产物</h3>
              <div className="space-y-2 text-sm">
                {[
                  { name: '副黄嘌呤 (Paraxanthine)', pct: '84%', path: '3-N-去甲基化', note: '主要产物，药理活性与咖啡因相似' },
                  { name: '可可碱 (Theobromine)', pct: '12%', path: '1-N-去甲基化', note: '心血管刺激、利尿作用' },
                  { name: '茶碱 (Theophylline)', pct: '4%', path: '7-N-去甲基化', note: '药理作用与咖啡因相似但毒性更强' },
                ].map((m, i) => (
                  <div key={i} className="flex items-center gap-3 p-2 bg-[#F5EDE0] rounded-lg">
                    <div className="w-12 h-12 rounded-lg bg-[#6F4E37] text-white flex items-center justify-center font-bold text-sm">
                      {m.pct}
                    </div>
                    <div className="flex-1">
                      <p className="text-xs font-semibold text-[#3C2415]">{m.name}</p>
                      <p className="text-[10px] text-[#8B7355]">{m.path}</p>
                      <p className="text-[10px] text-[#A89080]">{m.note}</p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Formula */}
      {activeSection === 'formula' && (
        <div className="space-y-3">
          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">📐 核心计算公式</h3>
              <div className="space-y-4">
                <div className="bg-[#F5EDE0] rounded-lg p-4">
                  <p className="text-xs text-[#8B7355] mb-1">公式 1 · 单次摄入后剩余量</p>
                  <p className="text-lg font-serif text-[#3C2415] text-center">A(N) = X × (1/2)^(N / t₁/₂)</p>
                  <div className="grid grid-cols-2 gap-2 mt-2 text-xs text-[#6F4E37]">
                    <span>X = 摄入剂量 (mg)</span>
                    <span>N = 经过时间 (h)</span>
                    <span>t₁/₂ = 消除半衰期 (h)</span>
                    <span>A(N) = N时刻体内量 (mg)</span>
                  </div>
                </div>

                <div className="bg-[#F5EDE0] rounded-lg p-4">
                  <p className="text-xs text-[#8B7355] mb-1">公式 2 · 多次摄入叠加</p>
                  <p className="text-base font-serif text-[#3C2415] text-center">A_total = Σ Xᵢ × (1/2)^((N-Tᵢ)/t₁/₂)</p>
                  <p className="text-xs text-[#8B7355] mt-1 text-center">Xi = 第i次剂量, Ti = 第i次时间</p>
                </div>

                <div className="bg-[#F5EDE0] rounded-lg p-4">
                  <p className="text-xs text-[#8B7355] mb-1">公式 3 · 一室模型 (含吸收相)</p>
                  <p className="text-sm font-serif text-[#3C2415] text-center leading-relaxed">
                    C(N) = (F·X·kₐ)/(Vd·(kₐ-kₑ)) × (e^(-kₑ·N) - e^(-kₐ·N))
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">📊 快速速查 (200mg单次)</h3>
              <div className="overflow-x-auto">
                <table className="w-full text-xs text-center">
                  <thead className="bg-[#F5EDE0]">
                    <tr>
                      <th className="p-2 text-left">时间</th>
                      <th className="p-2">快速(3h)</th>
                      <th className="p-2">正常(5h)</th>
                      <th className="p-2">慢速(7h)</th>
                      <th className="p-2">超慢(10h)</th>
                    </tr>
                  </thead>
                  <tbody>
                    {[
                      { t: '1h', v: ['159', '174', '181', '187'] },
                      { t: '2h', v: ['126', '152', '164', '174'] },
                      { t: '4h', v: ['79', '115', '135', '152'] },
                      { t: '8h', v: ['31', '66', '91', '115'] },
                      { t: '12h', v: ['12', '38', '61', '87'] },
                      { t: '24h', v: ['1', '7', '19', '38'] },
                    ].map((row, i) => (
                      <tr key={i} className="border-b border-[#E8DCC8]/50">
                        <td className="p-2 text-left font-medium text-[#6F4E37]">{row.t}</td>
                        {row.v.map((v, j) => (
                          <td key={j} className="p-2 text-[#3C2415]">{v}mg</td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </CardContent>
          </Card>
        </div>
      )}

      {/* Factors */}
      {activeSection === 'factors' && (
        <div className="space-y-3">
          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">⚡ 半衰期调整系数</h3>
              <div className="space-y-2">
                {[
                  { factor: 'CYP1A2 基因型 AA', mult: '×0.6', effect: '快', note: '快速代谢者' },
                  { factor: 'CYP1A2 基因型 AC', mult: '×1.4', effect: '慢', note: '慢速代谢者 (~45%)' },
                  { factor: 'CYP1A2 基因型 CC', mult: '×2.0', effect: '慢', note: '超慢代谢者 (~10%)' },
                  { factor: '吸烟', mult: '×0.6', effect: '快', note: '诱导 CYP1A2 活性' },
                  { factor: '口服避孕药', mult: '×2.0', effect: '慢', note: '抑制 CYP1A2' },
                  { factor: '妊娠晚期', mult: '×3.0', effect: '极慢', note: '孕酮抑制代谢' },
                  { factor: '肝功能不全(中度)', mult: '×3.0', effect: '极慢', note: '代谢能力下降75%' },
                  { factor: '饮酒', mult: '×1.4', effect: '慢', note: '抑制 CYP1A2 活性' },
                  { factor: '高龄 (>65岁)', mult: '×1.3', effect: '慢', note: '肝酶活性下降' },
                ].map((f, i) => (
                  <div key={i} className="flex items-center gap-2 p-2 rounded-lg bg-[#F5EDE0]/50">
                    <span className={`text-xs font-bold px-2 py-0.5 rounded-full ${
                      f.effect === '快' ? 'bg-emerald-100 text-emerald-700' :
                      f.effect === '慢' ? 'bg-amber-100 text-amber-700' :
                      'bg-red-100 text-red-700'
                    }`}>{f.mult}</span>
                    <div className="flex-1 min-w-0">
                      <p className="text-xs font-medium text-[#3C2415] truncate">{f.factor}</p>
                      <p className="text-[10px] text-[#A89080]">{f.note}</p>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card className="bg-white border-[#E8DCC8] shadow-sm">
            <CardContent className="p-4">
              <h3 className="font-semibold text-[#6F4E37] mb-3">🔬 CYP1A2 基因多态性</h3>
              <p className="text-xs text-[#8B7355] leading-relaxed mb-3">
                CYP1A2 是咖啡因代谢的关键酶，其活性由基因多态性 rs762551 决定。
                这一位点的变异解释了约 32-50% 的咖啡因代谢个体差异。
              </p>
              <div className="grid grid-cols-3 gap-2 text-center text-xs">
                <div className="bg-emerald-50 rounded-lg p-2 border border-emerald-100">
                  <p className="font-bold text-emerald-700">AA 型</p>
                  <p className="text-emerald-600">~45%</p>
                  <p className="text-[10px] text-emerald-500">t₁/₂ ≈ 3h</p>
                </div>
                <div className="bg-amber-50 rounded-lg p-2 border border-amber-100">
                  <p className="font-bold text-amber-700">AC 型</p>
                  <p className="text-amber-600">~45%</p>
                  <p className="text-[10px] text-amber-500">t₁/₂ ≈ 7h</p>
                </div>
                <div className="bg-red-50 rounded-lg p-2 border border-red-100">
                  <p className="font-bold text-red-700">CC 型</p>
                  <p className="text-red-600">~10%</p>
                  <p className="text-[10px] text-red-500">t₁/₂ ≈ 10h</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
}
