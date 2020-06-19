import {
    proxy_get_shared_data,
    proxy_set_shared_data
} from "@solo-io/proxy-runtime/imports";

import {
    Reference,
    WasmResultValues,
    log,
    LogLevelValues
} from "@solo-io/proxy-runtime/runtime";

export class RNG {
    private static MIN: number = 0;
    private static MAX: number = 4294967295; // u32 max
    private initialSeed: u32;
    private keyBuffer: ArrayBuffer;

    constructor(seed: u32, key: string) {
        this.keyBuffer = String.UTF8.encode(key);
        this.initialSeed = seed;
    }

    public next(): number {
        const seedBuf = new ArrayBuffer(4)
        const cas = new Reference<u32>()
        const seedU32Buf = Uint32Array.wrap(seedBuf);

        let setResult: WasmResultValues;
        do {
            const getResult = proxy_get_shared_data(
                changetype<usize>(this.keyBuffer),
                this.keyBuffer.byteLength,

                changetype<usize>(seedBuf),
                seedBuf.byteLength,

                cas.ptr()
            );

            log(LogLevelValues.info, "GET RESULT: " + getResult.toString());


            if (getResult !== WasmResultValues.Ok) {
                seedU32Buf[0] = this.initialSeed;
                cas.data = 0;
            } else {
                seedU32Buf[0] = this.xorshift(seedU32Buf[0]);
            }

            log(LogLevelValues.info, "SEED: " + seedU32Buf[0].toString());
            log(LogLevelValues.info, "CAS: " + cas.data.toString());

            setResult = proxy_set_shared_data(
                changetype<usize>(this.keyBuffer),
                this.keyBuffer.byteLength,

                changetype<usize>(seedBuf),
                seedBuf.byteLength,

                cas.data
            );

            log(LogLevelValues.info, "SET RESULT: " + setResult.toString());
        } while (setResult !== WasmResultValues.Ok);

        log(LogLevelValues.info, "SEED: " + seedU32Buf[0].toString());
        return (seedU32Buf[0] as number - RNG.MIN) / (RNG.MAX - RNG.MIN);
    }

    private xorshift(value: u32): u32 {
        // Xorshift*32
        // Based on George Marsaglia's work: http://www.jstatsoft.org/v08/i14/paper
        value ^= value << 13;
        value ^= value >> 17;
        value ^= value << 5;
        return value;
    }
}
