# blockchain

## ethereum-rpc-practice (과제 2)

Infura 엔드포인트를 통해 이더리움 메인넷의

- 최신 블록 번호(`eth_blockNumber`)
- 최신 블록의 트랜잭션 수(`eth_getBlockTransactionCountByNumber`)

를 가져오는 연습 프로젝트입니다.

동일한 기능을 아래 2가지 방식으로 구현했습니다.

- `json-rpc/index.js`: **순수 JSON-RPC 통신**(Node 내장 `fetch`)으로 직접 호출
- `ethers/index.js`: **ethers.js** 라이브러리로 호출

## 요구사항

- Node.js: 18 이상
- Infura API Key

## 설치

```bash
cd ethereum-rpc-practice
npm install
```

## .env 설정

`ethereum-rpc-practice/.env` 파일을 만들고 아래처럼 설정합니다.

```bash
INFURA_API_KEY=여기에_본인_INFURA_API_KEY
```

GitHub에 올릴 때는 실제 키 대신 예시 파일을 사용하세요.

- `ethereum-rpc-practice/.env.example`

## 실행 방법

프로젝트 폴더로 이동 후 실행합니다.

```bash
cd ethereum-rpc-practice
```

### 1) 순수 JSON-RPC(fetch) 방식

```bash
npm run json-rpc
```

### 2) ethers.js 방식

```bash
npm run ethers
```