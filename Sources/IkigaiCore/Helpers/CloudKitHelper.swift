//
//  CloudKitHelper.swift
//  IkigaiAPI
//
//  Created by Vince Davis on 3/24/25.
//
import Foundation

public struct CloudKitHelper {
    /// Converts a CloudKit schema DSL string to JSON.
    /// - Parameter schema: The CloudKit schema string.
    /// - Returns: A JSON string representing the schema, or nil if conversion fails.
    static public func schemaToJSON(schema: String) -> String? {
        // Remove the "DEFINE SCHEMA" header if it exists.
        let trimmedSchema = schema.trimmingCharacters(in: .whitespacesAndNewlines)
        let schemaContent = trimmedSchema.replacingOccurrences(of: "DEFINE SCHEMA", with: "")
        
        // Pattern to match each record type block.
        // This captures the record name and everything inside the parentheses.
        let recordPattern = #"RECORD TYPE\s+(\w+)\s*\((.*?)\);"#
        guard let recordRegex = try? NSRegularExpression(pattern: recordPattern, options: [.dotMatchesLineSeparators, .caseInsensitive]) else {
            return nil
        }
        
        let nsSchema = schemaContent as NSString
        let matches = recordRegex.matches(in: schemaContent, options: [], range: NSRange(location: 0, length: nsSchema.length))
        
        var records: [[String: Any]] = []
        
        // Process each record type.
        for match in matches {
            if match.numberOfRanges < 3 { continue }
            
            let recordName = nsSchema.substring(with: match.range(at: 1))
            let recordBody = nsSchema.substring(with: match.range(at: 2))
            
            var fields: [[String: Any]] = []
            var grants: [[String: String]] = []
            
            // Split the content by commas.
            // (This simple split works assuming no commas are inside a token like LIST<INT64>.)
            let components = recordBody.components(separatedBy: ",")
            for comp in components {
                let trimmedComp = comp.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedComp.isEmpty { continue }
                
                // If the component starts with "GRANT", treat it as a grant definition.
                if trimmedComp.uppercased().hasPrefix("GRANT") {
                    // Expected format: GRANT <PERMISSION> TO <ROLE>
                    let parts = trimmedComp.components(separatedBy: " ")
                    if parts.count >= 4 {
                        let permission = parts[1]
                        // Remove quotes from the role if present.
                        let role = parts[3].trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        grants.append(["permission": permission, "role": role])
                    }
                } else {
                    // Field definition.
                    // Expected format: fieldName fieldType [attributes...]
                    // Field names may be quoted if they contain special characters.
                    let fieldPattern = #"^(".*?"|\S+)\s+(\S+)(.*)$"#
                    if let fieldRegex = try? NSRegularExpression(pattern: fieldPattern, options: []),
                       let fieldMatch = fieldRegex.firstMatch(in: trimmedComp, options: [], range: NSRange(location: 0, length: trimmedComp.utf16.count)) {
                        
                        let nsComp = trimmedComp as NSString
                        let rawName = nsComp.substring(with: fieldMatch.range(at: 1))
                        let fieldName = rawName.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                        let fieldType = nsComp.substring(with: fieldMatch.range(at: 2))
                        
                        let attributesString = nsComp.substring(with: fieldMatch.range(at: 3))
                        // Split the remaining string into attributes (if any) and filter out empty tokens.
                        let attributes = attributesString
                            .split(separator: " ")
                            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty }
                        
                        fields.append([
                            "name": fieldName,
                            "type": fieldType,
                            "attributes": attributes
                        ])
                    }
                }
            }
            
            records.append([
                "recordType": recordName,
                "fields": fields,
                "grants": grants
            ])
        }
        
        // Wrap the records in a top-level dictionary.
        let jsonDict: [String: Any] = ["schema": records]
        
        // Convert the dictionary to pretty-printed JSON.
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: [.prettyPrinted]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
    
    public static var exampleSchema: String {
        return """
        DEFINE SCHEMA

            RECORD TYPE Item (
                "___createTime" TIMESTAMP QUERYABLE,
                "___createdBy"  REFERENCE,
                "___etag"       STRING,
                "___modTime"    TIMESTAMP,
                "___modifiedBy" REFERENCE,
                "___recordID"   REFERENCE QUERYABLE,
                comment         STRING QUERYABLE,
                url             STRING QUERYABLE,
                GRANT WRITE TO "_creator",
                GRANT CREATE TO "_icloud",
                GRANT READ TO "_world"
            );

            RECORD TYPE Newer (
                Cool            STRING QUERYABLE,
                "___createTime" TIMESTAMP QUERYABLE,
                "___createdBy"  REFERENCE,
                "___etag"       STRING,
                "___modTime"    TIMESTAMP QUERYABLE,
                "___modifiedBy" REFERENCE,
                "___recordID"   REFERENCE QUERYABLE,
                image           ASSET,
                GRANT WRITE TO "_creator",
                GRANT CREATE TO "_icloud",
                GRANT READ TO "_world"
            );

            RECORD TYPE Test (
                Age             INT64 QUERYABLE,
                Date            TIMESTAMP QUERYABLE,
                Image           ASSET,
                Tester          STRING QUERYABLE SEARCHABLE SORTABLE,
                "___createTime" TIMESTAMP QUERYABLE,
                "___createdBy"  REFERENCE QUERYABLE,
                "___etag"       STRING,
                "___modTime"    TIMESTAMP,
                "___modifiedBy" REFERENCE,
                "___recordID"   REFERENCE QUERYABLE,
                GRANT WRITE TO "_creator",
                GRANT CREATE TO "_icloud",
                GRANT READ TO "_world"
            );

            RECORD TYPE Users (
                "___createTime" TIMESTAMP,
                "___createdBy"  REFERENCE,
                "___etag"       STRING,
                "___modTime"    TIMESTAMP,
                "___modifiedBy" REFERENCE,
                "___recordID"   REFERENCE,
                roles           LIST<INT64>,
                GRANT WRITE TO "_creator",
                GRANT READ TO "_world"
            );
        """
    }
}
