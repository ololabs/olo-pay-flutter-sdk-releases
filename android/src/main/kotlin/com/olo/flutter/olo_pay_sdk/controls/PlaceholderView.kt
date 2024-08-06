package com.olo.flutter.olo_pay_sdk.controls

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.view.View
import android.widget.TextView
import com.google.android.material.shape.CornerFamily
import com.google.android.material.shape.MaterialShapeDrawable
import com.google.android.material.shape.ShapeAppearanceModel
import io.flutter.plugin.platform.PlatformView

internal class PlaceholderView(
    context: Context
) : PlatformView {
    val textView: TextView

    init {
        textView = TextView(context)
        textView.background = MaterialShapeDrawable(
            ShapeAppearanceModel()
                .toBuilder()
                .setAllCorners(CornerFamily.ROUNDED, 10.0f)
                .build()
        ).also {shape ->
            shape.strokeWidth = 2.0f
            shape.strokeColor = ColorStateList.valueOf(Color.GRAY)
            shape.fillColor = ColorStateList.valueOf(Color.TRANSPARENT)
            shape.setPadding(10, 5, 5, 5)
        }
    }

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    fun setText(text: String) {
        textView.text = text
    }
}