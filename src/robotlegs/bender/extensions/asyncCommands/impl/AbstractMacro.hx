package robotlegs.bender.extensions.asyncCommands.impl;
import Reflect;
import openfl.errors.Error;
import robotlegs.bender.extensions.asyncCommands.api.IAsyncCommand;
import robotlegs.bender.extensions.asyncCommands.api.IMacro;
import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;
import robotlegs.bender.extensions.asyncCommands.dsl.ISubCommandConfigurator;
import robotlegs.bender.extensions.asyncCommands.impl.SubCommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;

@:keepSub
class AbstractMacro extends AsyncCommand implements IMacro {
    @inject public var injector:IInjector;

    private var mappings:SubCommandMappingList = new SubCommandMappingList();

    @postConstruct
    public function initialize():Void {
        trace('initalize');
        this.injector = injector.createChild();

        prepare();
    }

    public function prepare():Void {
        throw new Error('Method must me overrided');
    }

    public function add(commandClass:Class<ICommand>):ISubCommandConfigurator {
        var mapping:SubCommandMapping = new SubCommandMapping(commandClass);
        mappings.addMapping(mapping);
        return mapping;
    }

    public function addInstance(command:ICommand):ISubCommandConfigurator {
        var mapping:SubCommandMapping = new SubCommandInstanceMapping(command);
        mappings.addMapping(mapping);
        return mapping;
    }

    public function remove(commandClass:Class<ICommand>):Void {
        mappings.removeMappingsFor(commandClass);
    }

    private static var EMPTY_ARGS:Array<Dynamic> = [];

    private function executeCommand(mapping:ISubCommandMapping):Void {
        var command:ICommand = null;

        trace('executing: ${mapping.commandClass}');

        var commandClass:Class<Dynamic> = mapping.commandClass;
        var payloads:Array<SubCommandPayload> = mapping.payloads;
        var hasPayloads:Bool = payloads.length > 0;

        if (hasPayloads) {
            mapPayloads(payloads);
        }

        if (mapping.guards.length == 0 || GuardsApprove.call(mapping.guards, injector)) {
            command = mapping.getOrCreateCommandInstance(injector);

            if (mapping.hooks.length > 0) {
                injector.map(commandClass).toValue(command);

                ApplyHooks.call(mapping.hooks, injector);

                injector.unmap(commandClass);
            }
        }

        if (hasPayloads) unmapPayloads(payloads);

        if (command != null && mapping.executeMethod != null) {
            var isAsync:Bool = Std.is(command, IAsyncCommand);
            if (isAsync) cast (command, IAsyncCommand).onComplete(commandCompleteHandler);

            Reflect.callMethod(command, Reflect.field(command, mapping.executeMethod), EMPTY_ARGS);
            if (!isAsync) commandCompleteHandler(true);
        } else {
            commandCompleteHandler(true);
        }
    }

    private function mapPayloads(payloads:Array<SubCommandPayload>):Void {
        for (payload in payloads) {
            injector.map(payload.type, payload.name).toValue(payload.data);
        }
    }

    private function unmapPayloads(payloads:Array<SubCommandPayload>):Void {
        for (payload in payloads) {
            injector.unmap(payload.type, payload.name);
        }
    }

    private function commandCompleteHandler(success:Bool):Void {
        throw new Error("Method must be overridden");
    }
}
