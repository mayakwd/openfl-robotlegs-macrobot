package robotlegs.bender.extensions.asyncCommands.impl;
import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;
import robotlegs.bender.extensions.asyncCommands.dsl.ISubCommandConfigurator;
import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;
@:keepSub
class SubCommandMapping implements ISubCommandMapping implements ISubCommandConfigurator {
    public var commandClass(default, null):Class<Dynamic>;
    @:isVar public var executeMethod(default, null):String = 'execute';

    @:isVar public var guards(default, null):Array<Dynamic> = [];
    @:isVar public var payloads(default, null):Array<SubCommandPayload> = [];
    @:isVar public var hooks(default, null):Array<Dynamic> = [];

    public inline function new(commandClass:Class<Dynamic>) {
        this.commandClass = commandClass;
    }

    public function withGuard(guard:Dynamic):ISubCommandConfigurator {
        guards.push(guard);

        return this;
    }

    public function withHook(hook:Dynamic):ISubCommandConfigurator {
        hooks.push(hook);

        return this;
    }

    public function withPayload(payload:Dynamic):ISubCommandConfigurator {
        if (Std.is(payload, SubCommandPayload)) {
            payloads.push(cast (payload, SubCommandPayload));
        } else {
            payloads.push(new SubCommandPayload(payload));
        }

        return this;
    }

    public function withExecuteMethod(name:String):ISubCommandConfigurator {
        executeMethod = name;
        return this;
    }

    public function getOrCreateCommandInstance(injector:IInjector):ICommand {
        return injector.getOrCreateNewInstance(commandClass);
    }
}
