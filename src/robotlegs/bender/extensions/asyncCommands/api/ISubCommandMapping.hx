package robotlegs.bender.extensions.asyncCommands.api;

import robotlegs.bender.extensions.asyncCommands.impl.SubCommandPayload;
import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.framework.api.IInjector;

interface ISubCommandMapping {
    var commandClass(default, null):Class<Dynamic>;
    var executeMethod(default, null):String;

    var guards(default, null):Array<Dynamic>;
    var hooks(default, null):Array<Dynamic>;
    var payloads(default, null):Array<SubCommandPayload>;

    function getOrCreateCommandInstance(injector:IInjector):ICommand;
}
