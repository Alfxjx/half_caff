import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { getFavorites, searchDrinks, DRINK_DATABASE } from '@/data/drinks';
import type { DrinkItem, UserProfile } from '@/types';

interface AddRecordProps {
  onAdd: (drink: DrinkItem) => void;
  onAddCustom: (name: string, amount: number) => void;
  currentAmount: number;
  profile: UserProfile;
}

export function AddRecord({ onAdd, onAddCustom, currentAmount, profile }: AddRecordProps) {
  const [search, setSearch] = useState('');
  const [activeCategory, setActiveCategory] = useState('favorites');
  const [customName, setCustomName] = useState('');
  const [customAmount, setCustomAmount] = useState('');
  const [showCustom, setShowCustom] = useState(false);

  const favorites = getFavorites();
  const searchResults = searchDrinks(search);

  const categories = [
    { id: 'favorites', label: '常用', icon: '⭐' },
    { id: 'coffee', label: '咖啡', icon: '☕' },
    { id: 'tea', label: '茶', icon: '🫖' },
    { id: 'soda', label: '饮料', icon: '🥤' },
    { id: 'energy', label: '能量', icon: '⚡' },
    { id: 'supplement', label: '补剂', icon: '💊' },
    { id: 'food', label: '食品', icon: '🍫' },
  ];

  const getDrinks = (): DrinkItem[] => {
    if (search.trim()) return searchResults;
    if (activeCategory === 'favorites') return favorites;
    return DRINK_DATABASE.filter(d => d.category === activeCategory);
  };

  const budget = profile.isPregnant ? 200 : profile.dailyBudget;
  const remaining = Math.max(0, budget - currentAmount);

  const handleCustomSubmit = () => {
    const amount = parseInt(customAmount);
    if (!customName.trim() || !amount || amount <= 0) return;
    onAddCustom(customName.trim(), amount);
    setCustomName('');
    setCustomAmount('');
    setShowCustom(false);
  };

  return (
    <div className="px-4 pt-6 pb-8 space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-[#3C2415]">记录摄入</h1>
        <p className="text-sm text-[#8B7355]">当前体内: <strong className="text-[#6F4E37]">{Math.round(currentAmount)}mg</strong> · 还可摄入: <strong className="text-[#6F4E37]">{Math.round(remaining)}mg</strong></p>
      </div>

      {/* Search */}
      <div className="relative">
        <Input
          placeholder="搜索饮品..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="pl-10 bg-white border-[#E8DCC8] text-[#3C2415] placeholder:text-[#A89080]"
        />
        <span className="absolute left-3 top-1/2 -translate-y-1/2 text-[#A89080]">🔍</span>
      </div>

      {/* Budget bar */}
      <div className="bg-white rounded-xl p-3 border border-[#E8DCC8] shadow-sm">
        <div className="flex justify-between text-xs mb-1">
          <span className="text-[#8B7355]">今日预算</span>
          <span className="text-[#6F4E37] font-medium">{Math.round(currentAmount)} / {budget}mg</span>
        </div>
        <div className="h-2 bg-[#E8DCC8] rounded-full overflow-hidden">
          <div
            className="h-full rounded-full transition-all"
            style={{
              width: `${Math.min(100, (currentAmount / budget) * 100)}%`,
              backgroundColor: currentAmount > budget * 0.8 ? '#C0392B' : currentAmount > budget * 0.6 ? '#E67E22' : '#6F4E37'
            }}
          />
        </div>
        {currentAmount > budget * 0.8 && (
          <p className="text-[10px] text-red-500 mt-1">⚠️ 接近日安全上限</p>
        )}
      </div>

      {/* Categories */}
      {!search.trim() && (
        <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
          {categories.map(cat => (
            <button
              key={cat.id}
              onClick={() => setActiveCategory(cat.id)}
              className={`flex items-center gap-1 px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-all ${
                activeCategory === cat.id
                  ? 'bg-[#6F4E37] text-white'
                  : 'bg-white text-[#6F4E37] border border-[#E8DCC8]'
              }`}
            >
              <span>{cat.icon}</span>
              {cat.label}
            </button>
          ))}
        </div>
      )}

      {/* Custom entry */}
      <Button
        variant="outline"
        onClick={() => setShowCustom(!showCustom)}
        className="w-full border-dashed border-[#D4A574] text-[#6F4E37] hover:bg-[#F5EDE0]"
      >
        {showCustom ? '− 收起自定义' : '+ 自定义记录'}
      </Button>

      {showCustom && (
        <Card className="bg-white border-[#E8DCC8] shadow-sm">
          <CardContent className="p-4 space-y-3">
            <div>
              <label className="text-xs text-[#8B7355] mb-1 block">饮品名称</label>
              <Input
                placeholder="例如: 手冲耶加雪菲"
                value={customName}
                onChange={e => setCustomName(e.target.value)}
                className="border-[#E8DCC8]"
              />
            </div>
            <div>
              <label className="text-xs text-[#8B7355] mb-1 block">咖啡因含量 (mg)</label>
              <Input
                type="number"
                placeholder="例如: 150"
                value={customAmount}
                onChange={e => setCustomAmount(e.target.value)}
                className="border-[#E8DCC8]"
              />
            </div>
            <Button
              onClick={handleCustomSubmit}
              className="w-full bg-[#6F4E37] hover:bg-[#5D4037] text-white"
              disabled={!customName.trim() || !parseInt(customAmount)}
            >
              记录 (+{customAmount || 0}mg)
            </Button>
          </CardContent>
        </Card>
      )}

      {/* Drink Grid */}
      <div className="grid grid-cols-2 gap-3">
        {getDrinks().map(drink => (
          <button
            key={drink.id}
            onClick={() => {
              const willExceed = currentAmount + drink.caffeineMg > budget;
              if (willExceed) {
                if (!confirm(`这将使你的日摄入量达到 ${Math.round(currentAmount + drink.caffeineMg)}mg，超过 ${budget}mg 的安全上限。仍要记录吗？`)) return;
              }
              onAdd(drink);
            }}
            className="bg-white rounded-xl p-4 border border-[#E8DCC8] shadow-sm text-left hover:shadow-md hover:border-[#D4A574] transition-all active:scale-95"
          >
            <div className="flex items-center gap-2 mb-2">
              <span className="text-2xl">{drink.icon}</span>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-[#3C2415] truncate">{drink.name}</p>
                {drink.volumeMl > 0 && (
                  <p className="text-[10px] text-[#A89080]">{drink.volumeMl}ml</p>
                )}
              </div>
            </div>
            <div className="flex items-baseline justify-between">
              <span className="text-lg font-bold" style={{ color: drink.color }}>{drink.caffeineMg}mg</span>
              {currentAmount + drink.caffeineMg > budget && (
                <span className="text-[10px] text-red-500">超预算</span>
              )}
            </div>
          </button>
        ))}
      </div>

      {getDrinks().length === 0 && (
        <div className="text-center py-10 text-[#A89080]">
          <p className="text-3xl mb-2">🔍</p>
          <p className="text-sm">未找到匹配的饮品</p>
        </div>
      )}
    </div>
  );
}
