import { describe, it, expect } from 'vitest';
import { calculateCotacaoRisco, calculateEXW } from './calculations';

describe('Calculations Utility', () => {
  describe('calculateCotacaoRisco', () => {
    it('should reduce price for Karams', () => {
      const result = calculateCotacaoRisco('Karams', 5.50, 0.10);
      expect(result).toBe(5.40);
    });

    it('should use fixed quote for Ferguile', () => {
      const result = calculateCotacaoRisco('Ferguile', 5.50, 4.95);
      expect(result).toBe(4.95);
    });

    it('should use fixed quote for Livintus', () => {
      const result = calculateCotacaoRisco('Livintus', 6.00, 5.00);
      expect(result).toBe(5.00);
    });
  });

  describe('calculateEXW', () => {
    it('should calculate EXW correctly with commission and gordura', () => {
      // 100 / 5 = 20
      // 20 + 10% (2) + 5% (1) = 23
      const result = calculateEXW(100, 5, 10, 5);
      expect(result).toBe(23.00);
    });

    it('should return 0 if cotacaoRisco is 0', () => {
      const result = calculateEXW(100, 0, 10, 5);
      expect(result).toBe(0);
    });
  });
});
