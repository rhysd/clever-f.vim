import * as React from 'react';
export interface FileEntry {
    parent: string;
    name: string;
    content: string;
}
export interface Props {
    memPath: string;
    vimrc?: string;
    children?: React.ReactElement<any>[];
    args?: string[];
    willStart?: () => void;
    didStart?: () => void;
    files?: FileEntry[];
    beep?: string;
}
export declare function writeFileToFS(file: FileEntry): void;
export interface FWProps {
    onUpload?: (parent: string, name: string) => void;
    children?: React.ReactElement<any>[];
}
export declare class FileUpload extends React.Component<FWProps, {}> {
    constructor(props: FWProps);
    private getUploader();
    private launchFileChooser();
    componentDidMount(): void;
    render(): any;
}
export default class Vim extends React.Component<Props, {}> {
    static defaultProps: {
        args: string[];
        files: FileEntry[];
        beep: string;
    };
    constructor(props: Props);
    private loadVimrc();
    private writeFiles();
    private prepareModule();
    componentDidMount(): void;
    render(): any;
}
