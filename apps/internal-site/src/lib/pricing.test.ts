import assert from 'node:assert/strict';
import { test } from 'node:test';
import { normalizePricingInput } from './pricing';

const taxRate = 0.1;

test('normalizePricingInput returns errors for missing required fields', () => {
  const result = normalizePricingInput({}, taxRate);
  assert.equal(result.values, null);
  assert.deepEqual(result.errors, [
    { field: 'treatment_id', message: '施術は必須です' },
    { field: 'plan_name', message: 'プラン名は必須です' },
    { field: 'price', message: '税抜価格は必須です' },
  ]);
});

test('normalizePricingInput normalizes required values and calculates tax', () => {
  const result = normalizePricingInput(
    {
      treatment_id: 't-1',
      plan_name: '1回',
      price: 1000,
      plan_type: 'single',
    },
    taxRate
  );
  assert.ok(result.values);
  assert.equal(result.values?.treatmentId, 't-1');
  assert.equal(result.values?.planName, '1回');
  assert.equal(result.values?.price, 1000);
  assert.equal(result.values?.priceTaxed, 1100);
  assert.equal(result.values?.planType, 'single');
});

test('normalizePricingInput trims strings and defaults plan_type', () => {
  const result = normalizePricingInput(
    {
      treatment_id: ' t-2 ',
      plan_name: ' 3回 ',
      price: '2000',
    },
    taxRate
  );
  assert.ok(result.values);
  assert.equal(result.values?.treatmentId, 't-2');
  assert.equal(result.values?.planName, '3回');
  assert.equal(result.values?.planType, 'single');
  assert.equal(result.values?.price, 2000);
  assert.equal(result.values?.priceTaxed, 2200);
});
