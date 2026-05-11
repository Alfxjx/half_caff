import type { DrinkItem } from '@/types';

export const DRINK_DATABASE: DrinkItem[] = [
  // Coffee
  { id: 'espresso_s', name: '意式浓缩 (Single)', caffeineMg: 65, volumeMl: 30, icon: '☕', color: '#3C2415', category: 'coffee' },
  { id: 'espresso_d', name: '意式浓缩 (Double)', caffeineMg: 130, volumeMl: 60, icon: '☕', color: '#3C2415', category: 'coffee' },
  { id: 'americano_s', name: '美式 (Short)', caffeineMg: 75, volumeMl: 240, icon: '☕', color: '#6F4E37', category: 'coffee' },
  { id: 'americano_t', name: '美式 (Tall)', caffeineMg: 150, volumeMl: 350, icon: '☕', color: '#6F4E37', category: 'coffee' },
  { id: 'americano_g', name: '美式 (Grande)', caffeineMg: 225, volumeMl: 480, icon: '☕', color: '#6F4E37', category: 'coffee' },
  { id: 'latte_t', name: '拿铁 (Tall)', caffeineMg: 75, volumeMl: 350, icon: '🥛', color: '#C4A77D', category: 'coffee' },
  { id: 'latte_g', name: '拿铁 (Grande)', caffeineMg: 150, volumeMl: 480, icon: '🥛', color: '#C4A77D', category: 'coffee' },
  { id: 'cappuccino', name: '卡布奇诺', caffeineMg: 75, volumeMl: 180, icon: '🍵', color: '#A0522D', category: 'coffee' },
  { id: 'coldbrew', name: '冷萃咖啡', caffeineMg: 200, volumeMl: 350, icon: '🧊', color: '#4682B4', category: 'coffee' },
  { id: 'coldbrew_l', name: '大杯冷萃', caffeineMg: 300, volumeMl: 600, icon: '🧊', color: '#4682B4', category: 'coffee' },
  { id: 'pourover', name: '手冲咖啡', caffeineMg: 110, volumeMl: 240, icon: '☕', color: '#8B4513', category: 'coffee' },
  { id: 'frenchpress', name: '法压壶咖啡', caffeineMg: 110, volumeMl: 240, icon: '☕', color: '#704214', category: 'coffee' },
  { id: 'mokapot', name: '摩卡壶咖啡', caffeineMg: 85, volumeMl: 60, icon: '☕', color: '#5D4037', category: 'coffee' },
  { id: 'instant', name: '速溶咖啡', caffeineMg: 70, volumeMl: 180, icon: '☕', color: '#A1887F', category: 'coffee' },
  { id: 'decaf', name: '低因咖啡', caffeineMg: 5, volumeMl: 240, icon: '☕', color: '#BCAAA4', category: 'coffee' },
  // Tea
  { id: 'blacktea', name: '红茶', caffeineMg: 45, volumeMl: 240, icon: '🫖', color: '#8B2500', category: 'tea' },
  { id: 'greentea', name: '绿茶', caffeineMg: 25, volumeMl: 240, icon: '🫖', color: '#6B8E23', category: 'tea' },
  { id: 'matcha', name: '抹茶', caffeineMg: 70, volumeMl: 240, icon: '🍵', color: '#2E7D32', category: 'tea' },
  { id: 'oolong', name: '乌龙茶', caffeineMg: 35, volumeMl: 240, icon: '🫖', color: '#DAA520', category: 'tea' },
  // Soda
  { id: 'coke', name: '可口可乐', caffeineMg: 34, volumeMl: 330, icon: '🥤', color: '#C62828', category: 'soda' },
  { id: 'pepsi', name: '百事可乐', caffeineMg: 38, volumeMl: 330, icon: '🥤', color: '#1565C0', category: 'soda' },
  // Energy
  { id: 'redbull', name: '红牛', caffeineMg: 80, volumeMl: 250, icon: '🥫', color: '#1565C0', category: 'energy' },
  { id: 'monster', name: 'Monster', caffeineMg: 160, volumeMl: 500, icon: '🥫', color: '#2E7D32', category: 'energy' },
  // Supplement
  { id: 'nodoz', name: '咖啡因片', caffeineMg: 200, volumeMl: 0, icon: '💊', color: '#5C6BC0', category: 'supplement' },
  { id: 'preworkout', name: '运动前补剂', caffeineMg: 200, volumeMl: 300, icon: '💊', color: '#E65100', category: 'supplement' },
  // Food
  { id: 'darkchoc', name: '黑巧克力 (30g)', caffeineMg: 25, volumeMl: 0, icon: '🍫', color: '#4E342E', category: 'food' },
  { id: 'milkchoc', name: '牛奶巧克力 (30g)', caffeineMg: 6, volumeMl: 0, icon: '🍫', color: '#A1887F', category: 'food' },
];

export const FAVORITES: string[] = ['americano_t', 'latte_g', 'espresso_d', 'coldbrew', 'blacktea', 'coke'];

export function getFavorites(): DrinkItem[] {
  return FAVORITES.map(id => DRINK_DATABASE.find(d => d.id === id)!).filter(Boolean);
}

export function searchDrinks(query: string): DrinkItem[] {
  if (!query.trim()) return [];
  const q = query.toLowerCase();
  return DRINK_DATABASE.filter(d => d.name.toLowerCase().includes(q));
}

export function getByCategory(cat: string): DrinkItem[] {
  return DRINK_DATABASE.filter(d => d.category === cat);
}
