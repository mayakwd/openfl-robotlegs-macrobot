package robotlegs.bender.extensions.asyncCommands.api;

import robotlegs.bender.extensions.commandCenter.api.ICommand;

interface IAsyncCommand extends ICommand {
    function onComplete(completeCallback:Bool -> Void):Void;
}
