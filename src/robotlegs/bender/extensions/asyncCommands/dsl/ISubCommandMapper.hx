package robotlegs.bender.extensions.asyncCommands.dsl;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

interface ISubCommandMapper {
    function add(commandClass:Class<ICommand>):ISubCommandConfigurator;
}
