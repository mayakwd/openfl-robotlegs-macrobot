package robotlegs.bender.extensions.asyncCommands.dsl;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

interface ISubCommandUnMapper {
    function remove(commandClass:Class<ICommand>):Void;
}
