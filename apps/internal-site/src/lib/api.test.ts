import assert from 'node:assert/strict';
import { test } from 'node:test';
import { parseIsPublishedParam } from './api';

test('parseIsPublishedParam returns null for null or invalid input', () => {
  assert.equal(parseIsPublishedParam(null), null);
  assert.equal(parseIsPublishedParam(''), null);
  assert.equal(parseIsPublishedParam('maybe'), null);
});

test('parseIsPublishedParam accepts 1/0', () => {
  assert.equal(parseIsPublishedParam('1'), 1);
  assert.equal(parseIsPublishedParam('0'), 0);
  assert.equal(parseIsPublishedParam(' 1 '), 1);
  assert.equal(parseIsPublishedParam(' 0 '), 0);
});

test('parseIsPublishedParam accepts true/false (case-insensitive)', () => {
  assert.equal(parseIsPublishedParam('true'), 1);
  assert.equal(parseIsPublishedParam('false'), 0);
  assert.equal(parseIsPublishedParam('TRUE'), 1);
  assert.equal(parseIsPublishedParam('False'), 0);
});
