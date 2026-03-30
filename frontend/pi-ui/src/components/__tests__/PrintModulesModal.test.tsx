import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { PrintModulesModal } from '../PrintModulesModal';

describe('PrintModulesModal', () => {
  const defaultProps = {
    isOpen: true,
    onClose: vi.fn(),
    onConfirm: vi.fn(),
    onExcelConfirm: vi.fn(),
    loading: false,
  };

  it('renders correctly when open', () => {
    render(<PrintModulesModal {...defaultProps} />);
    expect(screen.getByText('Imprimir / Exportar Módulos')).toBeDefined();
    expect(screen.getByText('Listagem Atual (Tela)')).toBeDefined();
    expect(screen.getByText('Reais (R$)')).toBeDefined();
  });

  it('calls onConfirm with correct values when Print button is clicked', () => {
    render(<PrintModulesModal {...defaultProps} />);
    
    // Change currency to EXW
    const exwRadio = screen.getByLabelText('Dólar (EXW)');
    fireEvent.click(exwRadio);

    // Change scope to All
    const allRadio = screen.getByLabelText('Todos os Registros');
    fireEvent.click(allRadio);

    // Change validity days
    const daysInput = screen.getByDisplayValue('30');
    fireEvent.change(daysInput, { target: { value: '45' } });

    const printButton = screen.getByText('🖨️ Imprimir');
    fireEvent.click(printButton);

    expect(defaultProps.onConfirm).toHaveBeenCalledWith('all', 'EXW', 45);
  });

  it('calls onExcelConfirm with correct values when Excel button is clicked', () => {
    render(<PrintModulesModal {...defaultProps} />);
    
    const excelButton = screen.getByText('📊 Excel');
    fireEvent.click(excelButton);

    expect(defaultProps.onExcelConfirm).toHaveBeenCalledWith('screen', 'BRL', 30);
  });

  it('does not render when isOpen is false', () => {
    const { container } = render(<PrintModulesModal {...defaultProps} isOpen={false} />);
    expect(container.firstChild).toBeNull();
  });
});
