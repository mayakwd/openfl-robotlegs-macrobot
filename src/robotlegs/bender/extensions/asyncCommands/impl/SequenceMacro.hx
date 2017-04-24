package robotlegs.bender.extensions.asyncCommands.impl;
import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;

class SequenceMacro extends AbstractMacro {
    @:isVar public var atomic(default, set):Bool = true;

    private var running:Bool = false;
    private var success:Bool = true;

    private var executionIndex:UInt;
    private var commands:Array<ISubCommandMapping>;

    override public function execute():Void {
        super.execute();

        running = true;
        executionIndex = 0;

        commands = mappings.getList();

        executeNext();
    }

    private function executeNext():Void {
        if (hasCommands()) {
            var mapping:ISubCommandMapping = commands[executionIndex];

            executionIndex++;

            executeCommand(mapping);
        } else {
            dispatchComplete(success);
        }
    }

    private function hasCommands():Bool {
        return commands != null && executionIndex < commands.length;
    }

    override private function commandCompleteHandler(success:Bool):Void {
        this.success = this.success && success;

        if (atomic || this.success) {
            executeNext();
        } else {
            dispatchComplete(false);
        }
    }

    override private function dispatchComplete(success:Bool):Void {
        super.dispatchComplete(success);

        running = false;

        this.success = true;
        executionIndex = 0;
        commands = null;
    }

    private function set_atomic(value:Bool):Bool {
        if (running) return atomic;

        return atomic = value;
    }
}
