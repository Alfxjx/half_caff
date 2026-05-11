import { useState } from 'react';
import { Switch } from '@/components/ui/switch';
import { Slider } from '@/components/ui/slider';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useCaffeineEngine } from '@/hooks/useCaffeineEngine';

interface ProfileProps {
  engine: ReturnType<typeof useCaffeineEngine>;
}

export function Profile({ engine }: ProfileProps) {
  const { profile, halfLife, updateProfile, records } = engine;
  const [showTest, setShowTest] = useState(false);
  const [testAnswers, setTestAnswers] = useState({
    q1: '', q2: '', q3: '', q4: '', q5: '',
  });

  const handleSwitch = (key: keyof typeof profile, val: boolean) => {
    updateProfile({ [key]: val } as any);
  };

  const handleTestSubmit = () => {
    let estimated = 5;
    if (testAnswers.q1 === 'fast') estimated = 3;
    if (testAnswers.q1 === 'slow') estimated = 7;
    if (testAnswers.q1 === 'vslow') estimated = 10;
    if (testAnswers.q2 === 'yes') estimated *= 0.6;
    if (testAnswers.q3 === 'yes') estimated *= 2;
    if (testAnswers.q4 === 'yes') estimated *= 1.4;
    if (testAnswers.q5 === 'over65') estimated *= 1.3;

    updateProfile({ halfLife: Math.max(1.5, Math.round(estimated * 10) / 10) });
    setShowTest(false);
  };

  const avgDaily = Math.round(records.reduce((s, r) => s + r.caffeineAmount, 0) / Math.max(1, records.length) * 10) / 10;

  return (
    <div className="px-4 pt-6 pb-8 space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-[#3C2415]">我的档案</h1>
        <p className="text-sm text-[#8B7355]">个性化代谢设置</p>
      </div>

      {/* Metabolism Type Card */}
      <Card className="bg-gradient-to-br from-[#6F4E37] to-[#5D4037] text-white shadow-lg">
        <CardContent className="p-5">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm opacity-80">你的代谢类型</p>
              <p className="text-xl font-bold mt-0.5">
                {halfLife <= 3 ? '🏃 快速代谢者' :
                 halfLife <= 5 ? '⚖️ 正常代谢者' :
                 halfLife <= 8 ? '🐢 慢速代谢者' :
                 halfLife <= 12 ? '🐌 超慢代谢者' : '⏳ 极慢代谢者'}
              </p>
              <p className="text-xs opacity-70 mt-1">
                估算半衰期: <strong className="text-white">{halfLife} 小时</strong>
              </p>
            </div>
            <div className="text-right">
              <div className="w-16 h-16 rounded-full bg-white/10 flex items-center justify-center">
                <span className="text-2xl font-bold">{halfLife}h</span>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Quick Metabolism Test */}
      <Button
        variant="outline"
        onClick={() => setShowTest(!showTest)}
        className="w-full border-[#D4A574] text-[#6F4E37] hover:bg-[#F5EDE0]"
      >
        {showTest ? '收起代谢测试' : '🧬 快速代谢类型测试'}
      </Button>

      {showTest && (
        <Card className="bg-white border-[#E8DCC8] shadow-sm">
          <CardContent className="p-4 space-y-4">
            <h3 className="text-sm font-semibold text-[#6F4E37]">回答以下问题估算你的代谢类型</h3>

            <div>
              <p className="text-xs text-[#8B7355] mb-2">1. 下午3点后喝咖啡，晚上入睡是否困难？</p>
              <div className="flex gap-2 flex-wrap">
                {[{ v: 'normal', l: '不影响' }, { v: 'slow', l: '有点影响' }, { v: 'vslow', l: '影响很大' }].map(opt => (
                  <button key={opt.v} onClick={() => setTestAnswers(p => ({ ...p, q1: opt.v }))}
                    className={`px-3 py-1 rounded-full text-xs ${testAnswers.q1 === opt.v ? 'bg-[#6F4E37] text-white' : 'bg-[#F5EDE0] text-[#6F4E37]'}`}>
                    {opt.l}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <p className="text-xs text-[#8B7355] mb-2">2. 你是否吸烟？</p>
              <div className="flex gap-2">
                {[{ v: 'yes', l: '是' }, { v: 'no', l: '否' }].map(opt => (
                  <button key={opt.v} onClick={() => setTestAnswers(p => ({ ...p, q2: opt.v }))}
                    className={`px-3 py-1 rounded-full text-xs ${testAnswers.q2 === opt.v ? 'bg-[#6F4E37] text-white' : 'bg-[#F5EDE0] text-[#6F4E37]'}`}>
                    {opt.l}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <p className="text-xs text-[#8B7355] mb-2">3. 是否服用口服避孕药？</p>
              <div className="flex gap-2">
                {[{ v: 'yes', l: '是' }, { v: 'no', l: '否' }].map(opt => (
                  <button key={opt.v} onClick={() => setTestAnswers(p => ({ ...p, q3: opt.v }))}
                    className={`px-3 py-1 rounded-full text-xs ${testAnswers.q3 === opt.v ? 'bg-[#6F4E37] text-white' : 'bg-[#F5EDE0] text-[#6F4E37]'}`}>
                    {opt.l}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <p className="text-xs text-[#8B7355] mb-2">4. 是否经常饮酒？</p>
              <div className="flex gap-2">
                {[{ v: 'yes', l: '是' }, { v: 'no', l: '否' }].map(opt => (
                  <button key={opt.v} onClick={() => setTestAnswers(p => ({ ...p, q4: opt.v }))}
                    className={`px-3 py-1 rounded-full text-xs ${testAnswers.q4 === opt.v ? 'bg-[#6F4E37] text-white' : 'bg-[#F5EDE0] text-[#6F4E37]'}`}>
                    {opt.l}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <p className="text-xs text-[#8B7355] mb-2">5. 年龄段？</p>
              <div className="flex gap-2 flex-wrap">
                {[{ v: 'under30', l: '<30' }, { v: '30-65', l: '30-65' }, { v: 'over65', l: '>65' }].map(opt => (
                  <button key={opt.v} onClick={() => setTestAnswers(p => ({ ...p, q5: opt.v }))}
                    className={`px-3 py-1 rounded-full text-xs ${testAnswers.q5 === opt.v ? 'bg-[#6F4E37] text-white' : 'bg-[#F5EDE0] text-[#6F4E37]'}`}>
                    {opt.l}
                  </button>
                ))}
              </div>
            </div>

            <Button onClick={handleTestSubmit} className="w-full bg-[#6F4E37] hover:bg-[#5D4037] text-white">
              估算我的代谢类型
            </Button>
          </CardContent>
        </Card>
      )}

      {/* Factors */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4 space-y-4">
          <h3 className="text-sm font-semibold text-[#6F4E37]">⚙️ 影响因素设置</h3>

          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-[#3C2415]">🚬 吸烟</p>
                <p className="text-[10px] text-[#8B7355]">半衰期 ×0.6 (加速代谢)</p>
              </div>
              <Switch checked={profile.isSmoker} onCheckedChange={v => handleSwitch('isSmoker', v)} />
            </div>
            <div className="h-px bg-[#E8DCC8]" />
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-[#3C2415]">💊 口服避孕药</p>
                <p className="text-[10px] text-[#8B7355]">半衰期 ×2.0 (减慢代谢)</p>
              </div>
              <Switch checked={profile.usesOralContraceptives} onCheckedChange={v => handleSwitch('usesOralContraceptives', v)} />
            </div>
            <div className="h-px bg-[#E8DCC8]" />
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-[#3C2415]">🤰 怀孕</p>
                <p className="text-[10px] text-[#8B7355]">半衰期 ×3.0 (极慢代谢)</p>
              </div>
              <Switch checked={profile.isPregnant} onCheckedChange={v => handleSwitch('isPregnant', v)} />
            </div>
            <div className="h-px bg-[#E8DCC8]" />
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-[#3C2415]">🍺 经常饮酒</p>
                <p className="text-[10px] text-[#8B7355]">半衰期 ×1.4</p>
              </div>
              <Switch checked={profile.drinksAlcohol} onCheckedChange={v => handleSwitch('drinksAlcohol', v)} />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Gene type */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4 space-y-4">
          <h3 className="text-sm font-semibold text-[#6F4E37]">🧬 CYP1A2 基因型 (可选)</h3>
          <p className="text-xs text-[#8B7355]">如果你有 23andMe 或其他基因检测结果，可以选择你的 CYP1A2 rs762551 基因型：</p>
          <div className="flex gap-2">
            {[{ v: 'unknown', l: '未知' }, { v: 'AA', l: 'AA (快)' }, { v: 'AC', l: 'AC (慢)' }, { v: 'CC', l: 'CC (极慢)' }].map(opt => (
              <button
                key={opt.v}
                onClick={() => updateProfile({ cyp1a2Genotype: opt.v as any })}
                className={`flex-1 py-2 rounded-lg text-xs font-medium transition-all ${
                  profile.cyp1a2Genotype === opt.v
                    ? 'bg-[#6F4E37] text-white'
                    : 'bg-[#F5EDE0] text-[#6F4E37] hover:bg-[#E8DCC8]'
                }`}
              >
                {opt.l}
              </button>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Liver disease */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4 space-y-3">
          <h3 className="text-sm font-semibold text-[#6F4E37]">🏥 肝功能状态</h3>
          <div className="grid grid-cols-4 gap-2">
            {[{ v: 'none', l: '正常' }, { v: 'mild', l: '轻度' }, { v: 'moderate', l: '中度' }, { v: 'severe', l: '重度' }].map(opt => (
              <button
                key={opt.v}
                onClick={() => updateProfile({ liverDisease: opt.v as any })}
                className={`py-2 rounded-lg text-xs font-medium transition-all ${
                  profile.liverDisease === opt.v
                    ? 'bg-[#6F4E37] text-white'
                    : 'bg-[#F5EDE0] text-[#6F4E37] hover:bg-[#E8DCC8]'
                }`}
              >
                {opt.l}
              </button>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Age & Budget */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4 space-y-4">
          <h3 className="text-sm font-semibold text-[#6F4E37]">⚙️ 其他设置</h3>
          <div>
            <label className="text-xs text-[#8B7355] mb-1 block">年龄: {profile.age} 岁</label>
            <Slider value={[profile.age]} onValueChange={v => updateProfile({ age: v[0] })} min={12} max={90} step={1} />
          </div>
          <div>
            <label className="text-xs text-[#8B7355] mb-1 block">日安全上限: {profile.dailyBudget}mg</label>
            <Slider value={[profile.dailyBudget]} onValueChange={v => updateProfile({ dailyBudget: v[0] })} min={100} max={600} step={10} />
          </div>
          <div>
            <label className="text-xs text-[#8B7355] mb-1 block">目标入睡时间</label>
            <Input
              type="time"
              value={profile.targetSleepTime}
              onChange={e => updateProfile({ targetSleepTime: e.target.value })}
              className="border-[#E8DCC8]"
            />
          </div>
        </CardContent>
      </Card>

      {/* Stats */}
      <Card className="bg-white border-[#E8DCC8] shadow-sm">
        <CardContent className="p-4">
          <h3 className="text-sm font-semibold text-[#6F4E37] mb-3">📊 个人数据</h3>
          <div className="grid grid-cols-2 gap-3 text-center">
            <div className="bg-[#F5EDE0] rounded-lg p-3">
              <p className="text-lg font-bold text-[#3C2415]">{records.length}</p>
              <p className="text-[10px] text-[#8B7355]">记录次数</p>
            </div>
            <div className="bg-[#F5EDE0] rounded-lg p-3">
              <p className="text-lg font-bold text-[#3C2415]">{avgDaily}mg</p>
              <p className="text-[10px] text-[#8B7355]">平均单次</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
