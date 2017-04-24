package robotlegs.bender.extensions.asyncCommands.api;

import robotlegs.bender.extensions.asyncCommands.dsl.ISubCommandMapper;
import robotlegs.bender.extensions.asyncCommands.dsl.ISubCommandUnMapper;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

interface IMacro extends ICommand extends ISubCommandMapper extends ISubCommandUnMapper {
    function prepare():Void;
}
