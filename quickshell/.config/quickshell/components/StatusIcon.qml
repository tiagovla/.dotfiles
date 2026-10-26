import QtQuick
import "StatusIconMetrics.js" as IconMetrics

Item {
    id: root

    required property string text
    required property color color
    required property string fontFamily
    property real size: 16
    property bool bold: true

    // Font sizes include different padding for each glyph and fallback font.
    // Use measured outlines to center the visible ink and preserve the value gap.
    readonly property rect inkBounds: {
        const bounds = fontFamily === IconMetrics.fontFamily && bold ? IconMetrics.bounds[text] : null;
        return bounds ? Qt.rect(bounds[0], bounds[1], bounds[2], bounds[3]) : metrics.tightBoundingRect(text);
    }
    readonly property real inkScale: size / Math.max(1, inkBounds.width, inkBounds.height)

    implicitWidth: inkBounds.width * inkScale
    implicitHeight: 26

    FontMetrics {
        id: metrics
        font.family: root.fontFamily
        font.pixelSize: 64
        font.bold: root.bold
    }

    Text {
        id: glyph
        text: root.text
        color: root.color
        font: metrics.font
        x: -root.inkBounds.x * root.inkScale
        y: (root.height - root.inkBounds.height * root.inkScale) / 2
            - (baselineOffset + root.inkBounds.y) * root.inkScale
        transform: Scale {
            xScale: root.inkScale
            yScale: root.inkScale
        }
    }
}
