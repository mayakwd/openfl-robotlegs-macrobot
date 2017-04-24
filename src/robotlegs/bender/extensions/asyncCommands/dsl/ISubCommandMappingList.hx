package robotlegs.bender.extensions.asyncCommands.dsl;

import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

interface ISubCommandMappingList {
    function addMapping(mapping:ISubCommandMapping):Void;
    function removeMapping(mapping:ISubCommandMapping):Void;
    function removeMappingsFor(commandClass:Class<ICommand>):Void;
    function removeAllMappings():Void;
    function getList():Array<ISubCommandMapping>;
}
