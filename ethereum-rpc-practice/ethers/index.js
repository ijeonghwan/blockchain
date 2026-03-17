import 'dotenv/config';
import { JsonRpcProvider } from 'ethers';

const INFURA_API_KEY = process.env.INFURA_API_KEY;
if (!INFURA_API_KEY) {
  console.error('INFURA_API_KEY is missing. Please set it in .env');
  process.exit(1);
}

const RPC_URL = `https://mainnet.infura.io/v3/${INFURA_API_KEY}`;

async function main() {
  const provider = new JsonRpcProvider(RPC_URL);

  const latestBlockNumber = await provider.getBlockNumber();
  const latestBlock = await provider.getBlock(latestBlockNumber);
  const txCount = latestBlock?.transactions?.length ?? 0;

  console.log(`Latest block number: ${latestBlockNumber}`);
  console.log(`Transaction count in latest block: ${txCount}`);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
