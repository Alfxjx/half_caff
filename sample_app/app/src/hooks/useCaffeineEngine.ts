import { useState, useCallback, useMemo } from 'react';
import type { UserProfile, IntakeRecord, DrinkItem, TimePoint } from '@/types';

const HALF_LIFE_PRESETS: Record<string, number> = {
  ultra_fast: 2, fast: 3, normal: 5, slow: 7, very_slow: 10,
};

const LIVER_MULTIPLIERS: Record<string, number> = {
  none: 1, mild: 2, moderate: 3, severe: 4,
};

function calcHalfLife(profile: UserProfile): number {
  let base = 5;
  if (profile.cyp1a2Genotype !== 'unknown') {
    base = { AA: 3, AC: 7, CC: 10 }[profile.cyp1a2Genotype] ?? 5;
  } else {
    base = HALF_LIFE_PRESETS[profile.halfLife <= 2 ? 'ultra_fast' : profile.halfLife <= 3 ? 'fast' : profile.halfLife <= 5 ? 'normal' : profile.halfLife <= 7 ? 'slow' : 'very_slow'] ?? 5;
  }
  if (profile.isSmoker) base *= 0.6;
  if (profile.usesOralContraceptives) base *= 2.0;
  if (profile.isPregnant) base *= 3.0;
  if (profile.drinksAlcohol) base *= 1.4;
  base *= LIVER_MULTIPLIERS[profile.liverDisease] ?? 1;
  if (profile.age > 65) base *= 1.3;
  return Math.max(1, Math.round(base * 10) / 10);
}

function caffeineAtTime(records: IntakeRecord[], targetTime: number, halfLife: number): number {
  let total = 0;
  for (const r of records) {
    const hours = (targetTime - r.timestamp) / 3600000;
    if (hours >= 0) {
      total += r.caffeineAmount * Math.pow(0.5, hours / halfLife);
    }
  }
  return total;
}

function generateTimeline(records: IntakeRecord[], halfLife: number, hoursAhead = 24): TimePoint[] {
  const now = Date.now();
  const points: TimePoint[] = [];
  for (let m = 0; m <= hoursAhead * 4; m++) {
    const t = now + m * 15 * 60 * 1000;
    const amount = caffeineAtTime(records, t, halfLife);
    const date = new Date(t);
    const label = date.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
    points.push({ time: t, amount, label });
  }
  return points;
}

function getAdvice(currentMg: number, _halfLife: number, profile: UserProfile): { text: string; type: 'safe' | 'warn' | 'danger' } {
  if (profile.isPregnant) {
    if (currentMg > 180) return { text: '已超过孕妇安全线(200mg)，建议停止摄入', type: 'danger' };
    if (currentMg > 120) return { text: '接近孕妇安全上限，谨慎摄入', type: 'warn' };
    return { text: '在孕妇安全范围内', type: 'safe' };
  }
  if (currentMg > 350) return { text: '接近日安全上限(400mg)，建议暂停', type: 'danger' };
  if (currentMg > 250) return { text: '摄入较高，下一杯建议少量', type: 'warn' };
  if (currentMg > 50) return { text: '可以安全再喝一杯(≤100mg)', type: 'safe' };
  return { text: '体内咖啡因已很低，随时可喝', type: 'safe' };
}

export function useCaffeineEngine() {
  const [profile, setProfile] = useState<UserProfile>({
    halfLife: 5, dailyBudget: 400, targetSleepTime: '23:00',
    isSmoker: false, usesOralContraceptives: false, isPregnant: false,
    liverDisease: 'none', age: 28, drinksAlcohol: false, cyp1a2Genotype: 'unknown',
  });

  const [records, setRecords] = useState<IntakeRecord[]>(() => {
    const now = Date.now();
    return [
      { id: '1', timestamp: now - 3.5 * 3600000, drinkName: '美式咖啡', caffeineAmount: 200, icon: '☕', color: '#6F4E37' },
      { id: '2', timestamp: now - 1 * 3600000, drinkName: '拿铁', caffeineAmount: 80, icon: '🥛', color: '#D4A574' },
    ];
  });

  const halfLife = useMemo(() => calcHalfLife(profile), [profile]);
  const currentAmount = useMemo(() => caffeineAtTime(records, Date.now(), halfLife), [records, halfLife]);
  const todayTotal = useMemo(() => {
    const startOfDay = new Date().setHours(0, 0, 0, 0);
    return records.filter(r => r.timestamp >= startOfDay).reduce((s, r) => s + r.caffeineAmount, 0);
  }, [records]);

  const timeline = useMemo(() => generateTimeline(records, halfLife, 24), [records, halfLife]);

  const safeSleepTime = useMemo(() => {
    const now = Date.now();
    for (let m = 0; m <= 24 * 4; m++) {
      const t = now + m * 15 * 60 * 1000;
      const amount = caffeineAtTime(records, t, halfLife);
      if (amount < 50) return t;
    }
    return now + 24 * 3600000;
  }, [records, halfLife]);

  const fullClearTime = useMemo(() => {
    const now = Date.now();
    for (let m = 0; m <= 48 * 4; m++) {
      const t = now + m * 15 * 60 * 1000;
      const amount = caffeineAtTime(records, t, halfLife);
      if (amount < 5) return t;
    }
    return now + 48 * 3600000;
  }, [records, halfLife]);

  const advice = useMemo(() => getAdvice(currentAmount, halfLife, profile), [currentAmount, halfLife, profile]);

  const addRecord = useCallback((drink: DrinkItem) => {
    const record: IntakeRecord = {
      id: Date.now().toString() + Math.random(),
      timestamp: Date.now(),
      drinkName: drink.name,
      caffeineAmount: drink.caffeineMg,
      icon: drink.icon,
      color: drink.color,
    };
    setRecords(prev => [...prev, record]);
  }, []);

  const addCustomRecord = useCallback((name: string, amount: number) => {
    const record: IntakeRecord = {
      id: Date.now().toString() + Math.random(),
      timestamp: Date.now(),
      drinkName: name,
      caffeineAmount: amount,
      icon: '☕',
      color: '#6F4E37',
    };
    setRecords(prev => [...prev, record]);
  }, []);

  const removeRecord = useCallback((id: string) => {
    setRecords(prev => prev.filter(r => r.id !== id));
  }, []);

  const updateProfile = useCallback((updates: Partial<UserProfile>) => {
    setProfile(prev => ({ ...prev, ...updates }));
  }, []);

  return {
    profile,
    halfLife,
    records,
    currentAmount,
    todayTotal,
    timeline,
    safeSleepTime,
    fullClearTime,
    advice,
    addRecord,
    addCustomRecord,
    removeRecord,
    updateProfile,
  };
}

export { caffeineAtTime, generateTimeline };
