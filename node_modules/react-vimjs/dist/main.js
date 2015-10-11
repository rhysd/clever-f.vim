var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
var React = require('react');
function writeFileToFS(file) {
    var create = global.Module['FS_createDataFile'];
    create(file.parent, file.name, file.content, true, true);
}
exports.writeFileToFS = writeFileToFS;
var FileUpload = (function (_super) {
    __extends(FileUpload, _super);
    function FileUpload(props) {
        _super.call(this, props);
    }
    FileUpload.prototype.getUploader = function () {
        return React.findDOMNode(this.refs['uploader']);
    };
    FileUpload.prototype.launchFileChooser = function () {
        this.getUploader().click();
    };
    FileUpload.prototype.componentDidMount = function () {
        var _this = this;
        this.getUploader().addEventListener('change', function (event) {
            var file = event.target.files[0];
            var reader = new FileReader();
            reader.onload = function (e) {
                writeFileToFS({
                    parent: '/root',
                    name: file.name,
                    content: e.target.result
                });
                if (_this.props.onUpload) {
                    _this.props.onUpload('/root', file.name);
                }
            };
            reader.readAsText(file);
        });
    };
    FileUpload.prototype.render = function () {
        return (React.createElement("div", {"className": 'vim-file-writer', "onClick": this.launchFileChooser.bind(this)}, React.createElement("div", null, this.props.children), React.createElement("input", {"className": 'hidden-uploader', "type": 'file', "ref": 'uploader'})));
    };
    return FileUpload;
})(React.Component);
exports.FileUpload = FileUpload;
var Vim = (function (_super) {
    __extends(Vim, _super);
    function Vim(props) {
        _super.call(this, props);
    }
    Vim.prototype.loadVimrc = function () {
        if (this.props.vimrc && typeof localStorage !== 'undefined' && !localStorage['vimjs/root/.vimrc']) {
            localStorage['vimjs/root/.vimrc'] = this.props.vimrc;
        }
    };
    Vim.prototype.writeDirs = function () {
        if (this.props.dirs === []) {
            return;
        }
        var create = global.Module['FS_createPath'];
        for (var _i = 0, _a = this.props.dirs; _i < _a.length; _i++) {
            var d = _a[_i];
            create(d.parent, d.name, true, true);
        }
    };
    Vim.prototype.writeFiles = function () {
        if (this.props.files === []) {
            return;
        }
        var create = global.Module['FS_createDataFile'];
        for (var _i = 0, _a = this.props.files; _i < _a.length; _i++) {
            var entry = _a[_i];
            create(entry.parent, entry.name, entry.content, true, true);
        }
    };
    Vim.prototype.prepareModule = function () {
        var _this = this;
        global.Module = {
            noInitialRun: false,
            noExitRuntime: true,
            arguments: this.props.args,
            preRun: [
                function () {
                    _this.loadVimrc.bind(_this);
                    vimjs.pre_run();
                    _this.writeDirs();
                    _this.writeFiles();
                    if (_this.props.willStart) {
                        _this.props.willStart();
                    }
                },
            ],
            postRun: [
                function () {
                    if (_this.props.didStart) {
                        _this.props.didStart();
                    }
                }
            ],
            print: function () {
                console.group.apply(console, arguments);
                console.groupEnd();
            },
            printErr: function () {
                console.group.apply(console, arguments);
                console.groupEnd();
            },
        };
        global.__vimjs_memory_initializer = this.props.memPath;
    };
    Vim.prototype.componentDidMount = function () {
        this.prepareModule();
    };
    Vim.prototype.render = function () {
        var font_test_props = {
            fontStyle: 'normal',
            fontVariant: 'normal',
            fontWeight: 'normal',
            fontStretch: 'normal',
            fontSize: '12px',
            lineHeight: 'normal',
            fontFamily: 'monospace',
        };
        return (React.createElement("div", {"className": 'root'}, React.createElement("div", {"id": 'vimjs-container', "className": 'vimjs-container'}, React.createElement("canvas", {"id": 'vimjs-canvas'}), this.props.children), React.createElement("audio", {"id": 'vimjs-beep', "src": this.props.beep}), React.createElement("input", {"id": 'vimjs-file', "className": 'vimjs-invisible', "type": 'file'}), React.createElement("div", React.__spread({"id": 'vimjs-font-test', "className": 'vimjs-invisible'}, font_test_props), "m"), React.createElement("div", {"id": 'vimjs-trigger-dialog', "className": 'modal'}, React.createElement("div", {"className": 'modal-dialog'}, React.createElement("div", {"className": 'modal-content'}, React.createElement("div", {"className": 'modal-header'}, React.createElement("h4", {"className": 'modal-title'}, "Ugly workaround for Chrome")), React.createElement("div", {"className": 'modal-body'}, React.createElement("button", {"id": 'vimjs-trigger-button', "type": 'button', "className": 'btn btn-primary'}, "Click Me")))))));
    };
    Vim.defaultProps = {
        args: ['/usr/local/share/vim/example.js'],
        files: [],
        dirs: [],
        beep: '',
    };
    return Vim;
})(React.Component);
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = Vim;
//# sourceMappingURL=main.js.map