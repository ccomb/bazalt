// End to end: the studio and the Haskell services speak the same JSON.
// Needs the services built (cabal build all) and the front built
// (studio/front/build.sh), and the ports 8080 and 8081 free.
import { test, expect } from '@playwright/test';
import { ChildProcess, execFileSync, spawn } from 'node:child_process';
import { existsSync, mkdtempSync, readFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';

const root = resolve(__dirname, '../../../..');
const dir = mkdtempSync(join(tmpdir(), 'bazalt-e2e-'));
const journal = (service: string) => join(dir, `${service}.txt`);
const services: ChildProcess[] = [];

// a fact some capability refused, with its reason; the services do not
// relay refusals yet, so the test hands it to the studio as if it came
// through the WebSocket
const refused = {
  meta: {
    uuid: '11111111-1111-4111-8111-111111111111',
    when: 1700000000,
    flow: { type: 'Error', value: 'raison' },
    from: ['Dumb'],
  },
  load: {
    what: 'AddedResourceType',
    load: { what: 'ResourceType', uuid: '22222222-2222-4222-8222-222222222222', parent: null },
  },
};

const bin = (exe: string) =>
  execFileSync('cabal', ['list-bin', '-v0', `exe:${exe}`], { cwd: root }).toString().trim();

const start = (exe: string, args: string[]) => {
  const p = spawn(bin(exe), args, { cwd: root, stdio: 'inherit' });
  services.push(p);
};

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

test.describe.configure({ mode: 'serial' });

test.beforeAll(async () => {
  start('store', ['-f', journal('store')]);
  await sleep(1000);
  start('ident', ['-f', journal('ident')]);
  start('dumb', ['-f', journal('dumb')]);
  start('studio', ['-d', join(root, 'studio/build'), '-f', journal('studio')]);
  await sleep(2000);
});

test.afterAll(() => services.forEach((p) => p.kill()));

// the store creates its journal with the first message
const processedLines = (what: string) =>
  (existsSync(journal('store')) ? readFileSync(journal('store'), 'utf8') : '')
    .split('\n')
    .filter((l) => l.includes(`"what":"${what}"`) && l.includes('"flow":{"type":"Processed"}'));

test('a resource type created in the studio is processed by the services', async ({ page }) => {
  await page.goto('http://localhost:8080/resource-type/add');
  for (let i = 0; i < 4; i++) await page.getByText('Next →').click();
  await page.getByText('Validate and finish').click();
  await expect.poll(() => processedLines('AddedResourceType').length, { timeout: 10000 }).toBe(1);
});

test('the studio shows a refused fact and a message it cannot read', async ({ page }) => {
  const receive = (message: string) =>
    page.evaluate((m) => (window as any).app.ports.messagesReceiver.send(m), message);
  await page.goto('http://localhost:8080/');
  await expect(page.getByText(/WS/)).toBeVisible();
  await receive(JSON.stringify(refused));
  await expect(page.getByText('Refused: raison')).toBeVisible();
  await receive(JSON.stringify({ ...refused, load: { what: 'NoSuchPayload', load: {} } }));
  await expect(page.getByText(/Error decoding received messages/)).toBeVisible();
});
