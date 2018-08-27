package robotlegs.bender.extensions.asyncCommands.impl;
import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;
class SubCommandInstanceMapping extends SubCommandMapping {
    private var instance:ICommand;

    public function new(instance:ICommand) {
        this.instance = instance;
        super(Type.getClass(instance));
    }

    override public function getOrCreateCommandInstance(injector:IInjector):ICommand {
        injector.injectInto(instance);
        return instance;
    }
}
