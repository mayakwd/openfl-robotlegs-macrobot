# Macrobot

Macro command utility for Robotlegs which provides the ability to execute batches of commands in sequential or parallel fashion.

**ORIGINAL NOTE** This project is a shameful port of the awesome work that [Aaronius](https://github.com/Aaronius) made for the first release of [Robotlegs](http://www.robotlegs.org/).

**NOTE** This is port the of AS3 library [Macrobot](https://github.com/alebianco/robotlegs-utilities-macrobot)
## Introduction

While using Robotlegs and encapsulating your business logic inside commands, you may find yourself in a situation where you wish to batch commands, instead of relying on events to trigger every step.  
Macrobot simplifies this process and provide two way to group commands:

**Sequence**: The commands will be executed in order one after the other. A command will not be executed until the previous one is complete. The macro itself will not be complete until all its commands are complete.

**Parallel**: The commands will be executed as quickly as possible, with no regards on the order in which they were registered. The macro itself will not be complete until all its commands are complete.

## Installation

This library can be installed through any of the following ways.

To use the latest release from haxelib:

    $ haxelib install robotlegs-macrobot

To use the latest development from GitHub:

    $ haxelib git robotlegs-macrobot https://github.com/mayakwd/openfl-robotlegs-macrobot/openfl-robotlegs-macrobot.git
    
To use a local copy as a development haxelib, clone this repo and link the source directory by executing:

    $ git clone https://github.com/mayakwd/openfl-robotlegs-macrobot/openfl-robotlegs-macrobot.git
    $ haxelib dev robotlegs-macrobot ./robotlegs-macrobot

## Project Setup

For inclusion into a Haxe project, add this library by updating your project.xml:

    <project>
        ...
        <haxelib name="robotlegs" />
        <haxelib name="robotlegs-macrobot" />
        ...
    </project>

## Usage

To create a macro command, extend on the two classes Macrobot provides: `ParallelMacro` or `SequenceMacro`.  
Override the prepare() method and add sub commands by calling `addSubCommand()` specifying the command class to use.  
At the appropriate time the command will be created, initiated by satisfying the injection points and then executed.  
This automated process of instantiation, injection, and execution is very similar to how commands are normally prepared and executed in Robotlegs.  
You could use _Guards_ and _Hooks_ as you would normally use with regular commands to control the execution workflow.  
Additionally you could use the `withPayloads()` method to add some data that can be used to satisfy the injection points of the sub commands. The data provided will be available to the guards and hooks applied to the sub command as well.

Here's an example of a simple sequential macro:
```haxe
class MyMacro extends SequenceMacro {
	override public function prepare() {
		add(CommandA);
		add(CommandB);
		add(CommandC);
	}
}
```

### Using Guards

Guards are used to approve or deny the execution of one of the subcommands.

```haxe
class DailyRoutine extends SequenceMacro {
    override public function prepare() {
        add(Work);
        add(Party).withGuards(IsFriday); // It will only party on fridays
        add(Sleep);
    }
}

class IsFriday implements IGuard {
    public function approve():Bool {
        return new Date().day == 5;
    }
}
```
Refer to the [Robotlegs documentation](https://github.com/robotlegs/robotlegs-framework/blob/master/src/robotlegs/bender/framework/readme-guards.md) for more details about Guards.

### Using Hooks

Hooks run before the subcommands. They are typically used to run custom actions based on environmental conditions.  
Hooks will run only if the applied Guards approve the execution of the command.

```haxe
class DailyRoutine extends SequenceMacro {
    override public function prepare() {
        add(Work);
        add(Party).withGuards(IsFriday); // It will only party on fridays
        add(Sleep).withHook(GoToHome); // Try to avoid sleeping at the office or the pub
    }
}

class IsFriday implements IHook {
    @inject public var me:Person;
	
    public function hook():Void {
        me.goHome();
    }
}
```
Refer to the [Robotlegs documentation](https://github.com/robotlegs/robotlegs-framework/blob/master/src/robotlegs/bender/framework/readme-hooks.md) for more details about Hooks.


### Using Payloads

Payloads are used to temporary inject some data, which would not be available otherwise, and make it available to the subcommand, it's guards and it's hooks.  

You can use pass the data to be injected directly to the `withPayloads()` method, for a normal injection.
```haxe
class Macro extends SequenceMacro {
    override public function prepare() {
        var data:SomeModel = new SomeModel();
        add(Action).withPayloads(data);
    }
}

class Action implements ICommand implements DescribedType {
    @inject public var data:SomeModel;
	
    public function execute():Void {
        data.property = 'value';
    }
}
```

Or you can use the `SubCommandPayload` class to create a more complex injection.
```haxe
class Macro extends SequenceMacro {
    override public function prepare() {
        var data:SomeModel = new SomeModel()
        var payload:SubCommandPayload = new SubCommandPayload(data).withName('mydata').ofClass(IModel)
        add(Action).withPayloads(payload);
    }
}

class Action implements ICommand implements DescribedType {
    @inject('mydata') public var data:IModel;
	
    public function execute():Void {
        data.property = 'value'
    }
}
```

### Asynchronous commands

While Macrobot can work with synchronous commands, it is most effective when you have to deal with asynchronous ones.  
Your sub command may wait for a response from a server or for user interaction before being marked as complete.  
In this case you command can subclass Macrobot's AsyncCommand and call `dispatchComplete()` when it should be marked as complete.  
`dispatchComplete()` receives a single parameter which reports whether the subcommand completed successfully.

Here's an example of a simulated asynchronous sub command:
```haxe
class DelayCommand extends AsyncCommand {
    private var timer:Timer;

    override public function execute():Void {
        super.execute();
        timer = new Timer(1000, 1);
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
        timer.start();
    }

    private function timerCompleteHandler(event:TimerEvent):Void {
        timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
        timer = null;
        dispatchComplete(true);
    }
}
   
class MyMacro extends SequenceMacro {
    override public function prepare():Void {
        add(DelayCommand);
        add(OtherCommand);
        registerCompleteCallback(onComplete);
    }
    
    private function onComplete(success):Void {
        trace('all commands have been executed')
    }
}
```

### Atomic execution

For sequential macros, when the_ atomic_ property is set to **false** (it is **true** by default) and one of the sub commands dispatches a failure (using `dispatchComplete(false)`), subsequent sub commands will not be executed and the macro itself will dispatch failure.

This behaviour does not apply to parallel commands.

## License

This project is free, open-source software under the MIT license.

Copyright (c) 2017 Ilya Malanin  
Copyright (c) 2011-2014 Alessandro Bianco   