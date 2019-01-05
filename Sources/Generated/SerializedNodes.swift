import Foundation
import FlatBuffersSwift

public final class SerializedNodes {
    public var childCount: [Int16]
    public var scalars: [UInt32]
    public init(childCount: [Int16] = [], scalars: [UInt32] = []) {
        self.childCount = childCount
        self.scalars = scalars
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
    public var childCount: FlatBuffersScalarVector<Int16, T> {

        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:0))
    }
    public var scalars: FlatBuffersScalarVector<UInt32, T> {

        return FlatBuffersScalarVector(reader: _reader, myOffset: _reader.offset(objectOffset: _myOffset, propertyIndex:1))
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
        o.childCount = selfReader.childCount.compactMap{$0}
        o.scalars = selfReader.scalars.compactMap{$0}

        return o
    }
}
extension FlatBuffersBuilder {
    public func insertSerializedNodes(childCount: Offset? = nil, scalars: Offset? = nil) throws -> (Offset, [Int?]) {
        var valueCursors = [Int?](repeating: nil, count: 2)
        try self.startObject(withPropertyCount: 2)
        if let childCount = childCount {
            valueCursors[0] = try self.insert(offset: childCount, toStartedObjectAt: 0)
        }
        if let scalars = scalars {
            valueCursors[1] = try self.insert(offset: scalars, toStartedObjectAt: 1)
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

        let childCount: Offset?
        if self.childCount.isEmpty {
            childCount = nil
        } else {
            try builder.startVector(count: self.childCount.count, elementSize: MemoryLayout<Int16>.stride)
            for o in self.childCount.reversed() {
                builder.insert(value: o)
            }
            childCount = builder.endVector()
        }
        let scalars: Offset?
        if self.scalars.isEmpty {
            scalars = nil
        } else {
            try builder.startVector(count: self.scalars.count, elementSize: MemoryLayout<UInt32>.stride)
            for o in self.scalars.reversed() {
                builder.insert(value: o)
            }
            scalars = builder.endVector()
        }
        let (myOffset, _) = try builder.insertSerializedNodes(
            childCount: childCount,
            scalars: scalars
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
