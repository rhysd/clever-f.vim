import * as React from 'react'

export interface FileEntry {
    parent: string;
    name: string;
    content: string;
}

export interface DirEntry {
    parent: string;
    name: string;
}

export interface Props {
    memPath: string;
    vimrc?: string;
    children?: React.ReactElement<any>[];
    args?: string[];
    willStart?: () => void;
    didStart?: () => void;
    files?: FileEntry[];
    dirs?: DirEntry[];
    beep?: string;
}

export function writeFileToFS(file: FileEntry) {
    const create = (global.Module as {[n: string]: Function})['FS_createDataFile'];
    create(file.parent, file.name, file.content, true, true);
}

export interface FWProps {
    onUpload?: (parent: string, name: string) => void;
    children?: React.ReactElement<any>[];
}

export class FileUpload extends React.Component<FWProps, {}> {
    constructor(props: FWProps) {
        super(props);
    }

    private getUploader() {
        return React.findDOMNode(this.refs['uploader']) as HTMLInputElement;
    }

    private launchFileChooser() {
        this.getUploader().click();
    }

    componentDidMount() {
        this.getUploader().addEventListener('change', (event: Event) => {
            const file = (event.target as HTMLInputElement).files[0];
            let reader = new FileReader();
            reader.onload = (e: any) => {
                writeFileToFS({
                    parent: '/root',
                    name: file.name,
                    content: e.target.result
                });
                if (this.props.onUpload) {
                    this.props.onUpload('/root', file.name);
                }
            };
            reader.readAsText(file);
        });
    }

    render() {
        return (
            <div className='vim-file-writer' onClick={this.launchFileChooser.bind(this)}>
                <div>
                    {this.props.children}
                </div>
                <input className='hidden-uploader' type='file' ref='uploader'/>
            </div>
        );
    }
}

export default class Vim extends React.Component<Props, {}> {
    public static defaultProps = {
        args: ['/usr/local/share/vim/example.js'],
        files: [] as FileEntry[],
        dirs: [] as DirEntry[],
        beep: '',
    }

    constructor(props: Props) {
        super(props);
    }

    private loadVimrc() {
        if (this.props.vimrc && typeof localStorage !== 'undefined' && !localStorage['vimjs/root/.vimrc']) {
            localStorage['vimjs/root/.vimrc'] = this.props.vimrc;
        }
    }

    private writeDirs() {
        if (this.props.dirs === []) {
            return;
        }

        const create = (global.Module as {[n: string]: Function})['FS_createPath'];
        for (const d of this.props.dirs) {
            create(d.parent, d.name, true, true);
        }
    }

    private writeFiles() {
        if (this.props.files === []) {
            return;
        }

        const create = (global.Module as {[n: string]: Function})['FS_createDataFile'];

        for (const entry of this.props.files) {
            create(entry.parent, entry.name, entry.content, true, true);
        }
    }

    private prepareModule() {
        global.Module = {
          noInitialRun: false,
          noExitRuntime: true,
          arguments: this.props.args,
          preRun: [
              () => {
                  this.loadVimrc.bind(this);
                  vimjs.pre_run();
                  this.writeDirs();
                  this.writeFiles();
                  if (this.props.willStart) {
                      this.props.willStart();
                  }
              },
          ],
          postRun: [
              () => {
                  if (this.props.didStart) {
                      this.props.didStart();
                  }
              }
          ],
          print: function() {
              console.group.apply(console, arguments);
              console.groupEnd();
          },
          printErr: function() {
              console.group.apply(console, arguments);
              console.groupEnd();
          },
        };
        global.__vimjs_memory_initializer = this.props.memPath;
    }

    componentDidMount() {
        this.prepareModule();
    }

    render() {
        const font_test_props = {
            fontStyle: 'normal',
            fontVariant: 'normal',
            fontWeight: 'normal',
            fontStretch: 'normal',
            fontSize: '12px',
            lineHeight: 'normal',
            fontFamily: 'monospace',
        };

        return (
            <div className='root'>
                <div id='vimjs-container' className='vimjs-container'>
                    <canvas id='vimjs-canvas'></canvas>
                    {this.props.children}
                </div>
                <audio id='vimjs-beep' src={this.props.beep}></audio>
                <input id='vimjs-file' className='vimjs-invisible' type='file'/>
                <div id='vimjs-font-test' className='vimjs-invisible' {...font_test_props}>m</div>
                <div id='vimjs-trigger-dialog' className='modal'>
                    <div className='modal-dialog'>
                        <div className='modal-content'>
                            <div className='modal-header'>
                                <h4 className='modal-title'>Ugly workaround for Chrome</h4>
                            </div>
                            <div className='modal-body'>
                                <button id='vimjs-trigger-button' type='button' className='btn btn-primary'>Click Me</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}

