// 1st
import Foundation
import Cocoa

enum Const {
  enum Option: String {
    case `in` = "-i"
    case out = "-o"
    case help = "-h"
  }

  static let productionList: [(size: CGSize, name: String)] = [
    // iPhone Notification iOS 7-13
    (CGSize(width: 40, height: 40), "icon-20@2x"),
    (CGSize(width: 60, height: 60), "icon-20@3x"),

    // iPhone Settings iOS 7-13
    (CGSize(width: 58, height: 58), "icon-29@2x"),
    (CGSize(width: 87, height: 87), "icon-29@3x"),

    // iPhone Spotlight - iOS 7-13
    (CGSize(width: 80, height: 80), "icon-40@2x"),
    (CGSize(width: 120, height: 120), "icon-40@3x"),

    // iPhone App iOS 7-13
    (CGSize(width: 120, height: 120), "icon-60@2x"),
    (CGSize(width: 180, height: 180), "icon-60@3x"),

    // iPad Notifications iOS 7-13
    (CGSize(width: 20, height: 20), "icon-20"),
    (CGSize(width: 40, height: 40), "icon-20@2x"),

    // iPad Settings iOS 7-13
    (CGSize(width: 29, height: 29), "icon-29"),
    (CGSize(width: 58, height: 58), "icon-29@2x"),

    // iPad Spotlight iOS 7-13
    (CGSize(width: 40, height: 40), "icon-40"),
    (CGSize(width: 80, height: 80), "icon-40@2x"),

    // iPad App iOS 7-13
    (CGSize(width: 76, height: 76), "icon-76"),
    (CGSize(width: 152, height: 152), "icon-76@2x"),

    // iPad Pro App iOS 9-13
    (CGSize(width: 167, height: 167), "icon-83.5@2x"),

    // iOS Marketing
    (CGSize(width: 512, height: 512), "icon-512"),
    (CGSize(width: 1024, height: 1024), "icon-1024"),
  ]
}

// MARK: - Props
let arguments: [String] = CommandLine.arguments
var `in`: String? = nil
var out: String? = nil

// MARK: - Option

let help = """

  [-i]: Please enter the path of the image to be converted after entering a space after the -i
  [-o]: Please describe the directory of the converted image after putting a space after the -o in the destination path.
  [-h]: You can see the help at -h.

"""

for (index, argument) in arguments.enumerated() {
  if argument == Const.Option.in.rawValue {
    `in` = arguments[index+1]
  } else if argument == Const.Option.out.rawValue {
    out = arguments[index+1]
  } else if argument == Const.Option.help.rawValue {
    print(help)
    exit(0)
  }
}

guard let input = `in` else {
  print("error: in is nil")
  exit(0)
}

guard let output = out else {
  print("error: out is nil")
  exit(0)
}

// MARK: - Title

// \のリテラルがめんどくさい
let icornTitle = """

　＿　　＿＿＿＿＿　　＿＿＿＿＿＿　　＿＿　　　＿_
｜　｜｜　　＿＿＿｜｜　　＿＿　　｜｜　 　\\ ｜　 ｜
｜　｜｜　｜　　　　｜　｜　　｜　｜｜　｜\\ \\｜　 ｜
｜　｜｜　｜　　　　｜　｜　　｜　｜｜　｜ \\ ｜　 ｜
｜　｜｜　｜＿＿＿　｜　｜＿＿｜　｜｜　｜  \\　　 ｜
｜＿｜｜＿＿＿＿＿｜｜＿＿＿＿＿＿｜｜＿｜   \\＿＿｜

"""
print(icornTitle)

// MARK: - Genarate

// inputから画像ファイルを取得
guard let image = NSImage(byReferencingFile: input) else {
  print("missing image at: \(input)")
  exit(0)
}

print("Acquire images from input")

let directoryPath = output.appending("/Icons")

do {
  try FileManager.default.createDirectory(
    atPath: directoryPath,
    withIntermediateDirectories: true,
    attributes: nil
  )
}
catch {
  print("error create directory.")
}

let newRep = image.representations[0] as! NSBitmapImageRep
let cgImage = newRep.cgImage!

for (newSize, name) in Const.productionList {
  let width = UInt(newSize.width)
  let height = UInt(newSize.height)
  let bitsPerComponent = UInt(8)
  let bytesPerRow = UInt(4) * width
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

  let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: Int(bitsPerComponent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
  let bitmapRect = NSMakeRect(0, 0, newSize.width, newSize.height)

  bitmapContext.draw(cgImage, in: bitmapRect)
  let newImageRef = bitmapContext.makeImage()!
  let newImage = NSBitmapImageRep(cgImage: newImageRef)

  guard let pngData = newImage.representation(using: .png, properties: [:]) else {
    print("Failed to generate the image.")
    exit(0)
  }

  print("Resize the image and change it to PNG format.")

  let fileURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(name+".png")

  print("The path of the file to be generated: \(fileURL)")

  do {
    try pngData.write(to: fileURL)
  }
  catch {
    print("error saving: \(error)")
  }
}

print("All done.")
exit(0)
