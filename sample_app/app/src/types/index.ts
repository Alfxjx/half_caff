export interface UserProfile {
  halfLife: number;
  dailyBudget: number;
  targetSleepTime: string;
  isSmoker: boolean;
  usesOralContraceptives: boolean;
  isPregnant: boolean;
  liverDisease: 'none' | 'mild' | 'moderate' | 'severe';
  age: number;
  drinksAlcohol: boolean;
  cyp1a2Genotype: 'AA' | 'AC' | 'CC' | 'unknown';
}

export interface IntakeRecord {
  id: string;
  timestamp: number;
  drinkName: string;
  caffeineAmount: number;
  icon: string;
  color: string;
}

export interface DrinkItem {
  id: string;
  name: string;
  caffeineMg: number;
  volumeMl: number;
  icon: string;
  color: string;
  category: 'coffee' | 'tea' | 'soda' | 'energy' | 'supplement' | 'food';
}

export interface TimePoint {
  time: number;
  amount: number;
  label: string;
}

export type TabId = 'dashboard' | 'timeline' | 'add' | 'explore' | 'profile';
