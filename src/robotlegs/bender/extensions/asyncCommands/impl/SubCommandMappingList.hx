package robotlegs.bender.extensions.asyncCommands.impl;
import robotlegs.bender.extensions.asyncCommands.api.ISubCommandMapping;
import robotlegs.bender.extensions.asyncCommands.dsl.ISubCommandMappingList;
import robotlegs.bender.extensions.commandCenter.api.ICommand;

@:final class SubCommandMappingList implements ISubCommandMappingList {
    private var mappings:Array<ISubCommandMapping>;
    private var mappingByCommand:Map<String, Array<ISubCommandMapping>>;

    public inline function new() {
        clear();
    }

    public function addMapping(mapping:ISubCommandMapping):Void {
        var className = Type.getClassName(mapping.commandClass);

        if (!mappingByCommand.exists(className)) {
            mappingByCommand.set(className, []);
        }

        mappingByCommand.get(className).push(mapping);
        mappings.push(mapping);
    }

    public function removeMapping(mapping:ISubCommandMapping):Void {
        var className = Type.getClassName(mapping.commandClass);

        if (mappingByCommand.exists(className)) {
            removeMappingFromArray(mapping, mappingByCommand.get(className));
        }

        removeMappingFromArray(mapping, mappings);
    }

    private function removeMappingFromArray(mapping:ISubCommandMapping, array:Array<ISubCommandMapping>):Void {
        var index = array.indexOf(mapping);
        if (index >= 0) {
            array.splice(index, 1);
        }
    }

    public function removeMappingsFor(commandClass:Class<ICommand>):Void {
        var className = Type.getClassName(commandClass);

        if (mappingByCommand.exists(className)) {
            var mappings:Array<ISubCommandMapping> = mappingByCommand.get(className);

            for (mapping in mappings) {
                removeMappingFromArray(mapping, this.mappings);
            }

            mappingByCommand.remove(className);
        }
    }

    public function removeAllMappings():Void {
        clear();
    }

    public function getList():Array<ISubCommandMapping> {
        return mappings.copy();
    }

    private function clear():Void {
        mappings = [];
        mappingByCommand = new Map<String, Array<ISubCommandMapping>>();
    }

}
