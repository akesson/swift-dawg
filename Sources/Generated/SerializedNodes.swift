import Foundation
import FlatBuffersSwift

public final class SerializedNodes {
    public var array: [SerializedNode]
    public init(array: [SerializedNode] = []) {
        self.array = array
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension SerializedNodes.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : SerializedNodes.Direct<T>, t2 : SerializedNodes.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var array: FlatBuffersTableVector<SerializedNode.Direct<T>, T> {

        return FlatBuffersTableVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:0))
    }
}
extension SerializedNodes {
    public static func from(data: Data) -> SerializedNodes? {
        let reader = FlatBuffersMemoryReader(data: data, withoutCopy: false)
        return SerializedNodes.from(selfReader: Direct<FlatBuffersMemoryReader>(reader: reader))
    }
    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> SerializedNodes? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? SerializedNodes {
            return o
        }
        let o = SerializedNodes()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.array = selfReader.array.compactMap{ SerializedNode.from(selfReader:$0) }

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertSerializedNodes(array: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 1)
        try self.startObject(withPropertyCount: 1)
        if let array = array {
            valueCursors[0] = try self.insert(offset: array, toStartedObjectAt: 0)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension SerializedNodes {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }

        let array: Offset?
        if self.array.isEmpty {
            array = nil
        } else {
            let offsets = try self.array.reversed().map{ try $0.insert(builder) }
            try builder.startVector(count: self.array.count, elementSize: MemoryLayout<Offset>.stride)
            for (_, o) in offsets.enumerated() {
                try builder.insert(offset: o)
            }
            array = builder.endVector()
        }
        let (myOffset, _) = try builder.insertSerializedNodes(
            array: array
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }
    public func makeData(withOptions options : FlatBuffersBuilderOptions = FlatBuffersBuilderOptions()) throws -> Data {
        let builder = FlatBuffersBuilder(options: options)
        let offset = try insert(builder)
        try builder.finish(offset: offset, fileIdentifier: nil)
        
        return builder.makeData
    }
}
public final class SerializedNode {
    public var character: String?
    public var word: String?
    public var children: [UInt32]
    public init(character: String? = nil, word: String? = nil, children: [UInt32] = []) {
        self.character = character
        self.word = word
        self.children = children
    }
    public struct Direct<T : FlatBuffersReader> : Hashable, FlatBuffersDirectAccess {
        fileprivate let _reader : T
        fileprivate let _myOffset : Offset
    }
}
extension SerializedNode.Direct {
    public init?<R : FlatBuffersReader>(reader: R, myOffset: Offset? = nil) {
        guard let reader = reader as? T else {
            return nil
        }
        self._reader = reader
        if let myOffset = myOffset {
            self._myOffset = myOffset
        } else {
            if let rootOffset = reader.rootObjectOffset {
                self._myOffset = rootOffset
            } else {
                return nil
            }
        }
    }
    public var hashValue: Int { return Int(_myOffset) }
    public static func ==<T>(t1 : SerializedNode.Direct<T>, t2 : SerializedNode.Direct<T>) -> Bool {
        return t1._reader.isEqual(other: t2._reader) && t1._myOffset == t2._myOffset
    }
    public var character: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:0) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var word: UnsafeBufferPointer<UInt8>? {
        guard let offset = _reader.offset(objectOffset: _myOffset, propertyIndex:1) else {return nil}
        return _reader.stringBuffer(stringOffset: offset)
    }
    public var children: FlatBuffersScalarVector<UInt32, T> {

        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:2))
    }
}
extension SerializedNode {

    fileprivate static func from(selfReader: Direct<FlatBuffersMemoryReader>?) -> SerializedNode? {
        guard let selfReader = selfReader else {
            return nil
        }
        if let o = selfReader._reader.cache?.objectPool[selfReader._myOffset] as? SerializedNode {
            return o
        }
        let o = SerializedNode()
        selfReader._reader.cache?.objectPool[selfReader._myOffset] = o
        o.character = selfReader.character§
        o.word = selfReader.word§
        o.children = selfReader.children.compactMap{$0}

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertSerializedNode(character: Offset? = nil, word: Offset? = nil, children: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 3)
        try self.startObject(withPropertyCount: 3)
        if let character = character {
            valueCursors[0] = try self.insert(offset: character, toStartedObjectAt: 0)
        }
        if let word = word {
            valueCursors[1] = try self.insert(offset: word, toStartedObjectAt: 1)
        }
        if let children = children {
            valueCursors[2] = try self.insert(offset: children, toStartedObjectAt: 2)
        }
        return try (self.endObject(), valueCursors)
    }
}
extension SerializedNode {
    func insert(_ builder : FlatBuffersBuilder) throws -> Offset {
        if builder.options.uniqueTables {
            if let myOffset = builder.cache[ObjectIdentifier(self)] {
                return myOffset
            }
        }

        let character = self.character == nil ? nil : try builder.insert(value: self.character)
        let word = self.word == nil ? nil : try builder.insert(value: self.word)
        let children: Offset?
        if self.children.isEmpty {
            children = nil
        } else {
            try builder.startVector(count: self.children.count, elementSize: MemoryLayout<UInt32>.stride)
            for o in self.children.reversed() {
                builder.insert(value: o)
            }
            children = builder.endVector()
        }
        let (myOffset, _) = try builder.insertSerializedNode(
            character: character,
            word: word,
            children: children
        )

        if builder.options.uniqueTables {
            builder.cache[ObjectIdentifier(self)] = myOffset
        }

        return myOffset
    }

}
