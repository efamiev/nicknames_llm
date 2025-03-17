import http from "k6/http";

import { sleep, check } from "k6";

// Current liveview session from browser
const cookie = "SFMyNTY.g3QAAAADbQAAAAtfY3NyZl90b2tlbm0AAAAYRnA5NFlCNjE0UjJsUzNZemZxRHZ1dnlwbQAAAA5saXZlX3NvY2tldF9pZG0AAAA7dXNlcnNfc2Vzc2lvbnM6TVoxZXpBa3RvUGp2N2pRSm9UTGhRb2R1STRqS0FVeS1NM2FqQnk0cm5SWT1tAAAACnVzZXJfdG9rZW5tAAAAIDGdXswJLaD47-40CaEy4UKHbiOIygFMvjN2owcuK50W.oW3HM_-yE9vlmdehGPAsB33bzU0DlIk2aiwEMR7KY0I";

export default function () {
  let res = http.get("http://localhost/life_complexities", {
    // dont follow authentication failure redirects
    // redirects: 0,
    cookies: {
      _life_complex_key: cookie,
    },
  });

  check(res, {
    "status 200": (r) => r.status === 200,
    "contains header": (r) => r.body.includes("Listing Life complexities"),
  });

  sleep(1);
}
