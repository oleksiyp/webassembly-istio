import {RNG} from "./RNG";

export * from "@solo-io/proxy-runtime/proxy"; // this exports the required functions for the proxy to interact with us.

import {
    Context,
    ContextHelper,
    FilterHeadersStatusValues,
    registerRootContext,
    RootContext,
    RootContextHelper,
    GrpcStatusValues,
    send_local_response,
    continue_request,
    log,
    LogLevelValues
} from "@solo-io/proxy-runtime";


class RandomFailRoot extends RootContext {
    createContext(context_id: u32): Context {
        return ContextHelper.wrap(new RandomFailFilter(context_id, this));
    }
}

class RandomFailFilter extends Context {
    context: RandomFailRoot;
    rng: RNG;

    constructor(context_id: u32, context: RandomFailRoot) {
        super(context_id, context);
        this.context = context;
        this.rng = new RNG(1222, "random_seed");
    }

    onRequestHeaders(a: u32): FilterHeadersStatusValues {
        let rnd = this.rng.next();

        log(LogLevelValues.info, "Random value: " + rnd.toString());

        if (rnd < 0.7) {
            continue_request();
            return FilterHeadersStatusValues.Continue;
        } else {
            send_local_response(404, "internal server error", new ArrayBuffer(0), [], GrpcStatusValues.NotFound);
            return FilterHeadersStatusValues.StopIteration;
        }
    }

}

registerRootContext((context_id: u32) => {
    return RootContextHelper.wrap(new RandomFailRoot(context_id));
}, "random_fail");

