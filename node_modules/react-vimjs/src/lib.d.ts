/// <reference path="../typings/tsd.d.ts" />

declare module NodeJS {
    interface Global {
        Module: Object; // TODO
        __vimjs_memory_initializer: string;
    }
}

declare var vimjs: any;
