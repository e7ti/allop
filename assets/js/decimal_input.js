// Campos decimais opt-in: o usuario digita os algarismos, sem precisar da virgula.
(() => {
    const selector = 'input[data-decimal-places]';
    const places = input => Number(input.dataset.decimalPlaces || 2);
    function format(digits, precision) {
        digits = digits.replace(/^0+(?=\d)/, '').padStart(precision + 1, '0');
        const integer = digits.slice(0, -precision).replace(/\B(?=(\d{3})+(?!\d))/g, '.');
        return integer + ',' + digits.slice(-precision);
    }
    function canonical(input) {
        const value = input.value.trim();
        return value.includes(',') ? value.replace(/\./g, '').replace(',', '.') : value;
    }
    function set(input, value) {
        input.setCustomValidity('');
        if (value === '' || value === null || value === undefined) input.value = '';
        else {
            const numeric = Number(String(value).includes(',') ? String(value).replace(/\./g, '').replace(',', '.') : value);
            input.value = Number.isFinite(numeric) && numeric >= 0 ? format(numeric.toFixed(places(input)).replace('.', ''), places(input)) : String(value);
        }
        input.dataset.decimalPrevious = input.value;
    }
    function attach(input, precision = 2) {
        input.type = 'text'; input.inputMode = 'numeric'; input.dataset.decimalPlaces = String(precision);
        input.classList.add('allop-decimal'); input.autocomplete = 'off';
        set(input, input.value);
    }
    document.addEventListener('input', event => {
        const input = event.target;
        if (!(input instanceof HTMLInputElement) || !input.matches(selector)) return;
        input.setCustomValidity('');
        if (input.value.includes('-')) { input.setCustomValidity('Informe um valor positivo ou zero.'); return; }
        const digits = input.value.replace(/\D/g, '').replace(/^0+(?=\d)/, '');
        if (digits.length > Number(input.dataset.decimalMaxDigits || 15)) input.value = input.dataset.decimalPrevious || '';
        else input.value = digits === '' ? '' : format(digits, places(input));
        input.dataset.decimalPrevious = input.value;
        input.setSelectionRange(input.value.length, input.value.length);
    }, true);
    document.addEventListener('DOMContentLoaded', () => document.querySelectorAll(selector).forEach(input => attach(input, places(input))));
    window.AllopDecimal = { attach, set, canonical };
})();
