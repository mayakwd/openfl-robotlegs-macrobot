package robotlegs.bender.extensions.asyncCommands.impl;
import org.swiftsuspenders.utils.DescribedType;
import robotlegs.bender.extensions.asyncCommands.api.IAsyncCommand;
import robotlegs.bender.framework.api.IContext;

@:keepSub
class AsyncCommand implements IAsyncCommand implements DescribedType {
    @inject public var context:IContext;

    private var completeListeners:Array<Bool -> Void>;

    public function new() {}

    public function onComplete(completeCallback:Bool -> Void):Void {
        if (completeListeners == null) {
            completeListeners = [];
        }

        completeListeners.push(completeCallback);
    }

    public function execute():Void {
        context.detain(this);
    }

    private function dispatchComplete(success:Bool):Void {
        context.release(this);

        if (completeListeners != null) {
            for (listener in completeListeners) {
                listener(success);
            }

            completeListeners = null;
        }
    }

}
