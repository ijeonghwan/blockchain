import 'dotenv/config';

const INFURA_API_KEY = process.env.INFURA_API_KEY;
if (!INFURA_API_KEY) {
  console.error('INFURA_API_KEY is missing. Please set it in .env');
  process.exit(1);
}

const RPC_URL = `https://mainnet.infura.io/v3/${INFURA_API_KEY}`;

async function rpc(method, params = []) {
  const res = await fetch(RPC_URL, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: Date.now(),
      method,
      params,
    }),
  });

  if (!res.ok) {
    const text = await res.text().catch(() => '');
    throw new Error(`HTTP ${res.status} ${res.statusText}${text ? ` - ${text}` : ''}`);
  }

  const data = await res.json();
  if (data.error) {
    throw new Error(`RPC Error (${data.error.code}): ${data.error.message}`);
  }
  return data.result;
}

function hexToNumber(hex) {
  return Number.parseInt(hex, 16);
}

async function main() {
  const latestBlockHex = await rpc('eth_blockNumber');
  const latestBlockNumber = hexToNumber(latestBlockHex);

  const txCountHex = await rpc('eth_getBlockTransactionCountByNumber', [latestBlockHex]);
  const txCount = hexToNumber(txCountHex);

  console.log(`Latest block number: ${latestBlockNumber} (hex: ${latestBlockHex})`);
  console.log(`Transaction count in latest block: ${txCount} (hex: ${txCountHex})`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
