package robotlegs.bender.extensions.asyncCommands.impl;
import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;

class ParallelMacro extends AbstractMacro {
    private var running:Bool = false;
    private var success:Bool = true;

    private var commands:Array<ISubCommandMapping>;
    private var executionCount:UInt = 0;

    override public function execute():Void {
        super.execute();

        commands = mappings.getList();

        if (hasCommands()) {
            running = true;

            for (mapping in commands) {
                if (!success) break;

                executeCommand(mapping);
            }
        } else {
            dispatchComplete(true);
        }
    }

    private function hasCommands():Bool {
        return mappings != null && commands.length > 0;
    }

    override private function commandCompleteHandler(success:Bool):Void {
        executionCount++;

        this.success = this.success && success;

        if (running && (!this.success || executionCount == commands.length)) {
            dispatchComplete(this.success);
        }
    }

    override private function dispatchComplete(success:Bool):Void {
        super.dispatchComplete(success);

        running = false;

        this.success = true;

        executionCount = 0;
        commands = null;
    }
}
