package robotlegs.bender.extensions.asyncCommands.dsl;
interface ISubCommandConfigurator {
    function withGuard(guard:Dynamic):ISubCommandConfigurator;

    function withHook(hook:Dynamic):ISubCommandConfigurator;

    function withPayload(payload:Dynamic):ISubCommandConfigurator;

    function withExecuteMethod(name:String):ISubCommandConfigurator;
}
