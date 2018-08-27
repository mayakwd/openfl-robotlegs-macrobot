package robotlegs.bender.extensions.asyncCommands.impl;

@:final class SubCommandPayload {
    public var name(get, null):String;
    public var type(get, null):Class<Dynamic>;
    public var data(default, null):Dynamic;

    public function new(data:Dynamic, type:Class<Dynamic> = null) {
        if (data == null) {
            throw "Payload data can't be null";
        }

        this.data = data;
        this.type = type;
    }

    public function withName(name:String):SubCommandPayload {
        this.name = name;
        return this;
    }

    public function ofClass(type:Class<Dynamic>):SubCommandPayload {
        this.type = type;
        return this;
    }

    private function get_name():String {
        return name == null ? "" : name;
    }

    private function get_type():Class<Dynamic> {
        return type == null ? Type.getClass(data) : type;
    }
}
