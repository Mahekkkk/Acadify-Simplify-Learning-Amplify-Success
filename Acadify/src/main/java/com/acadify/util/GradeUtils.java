package com.acadify.util;

public class GradeUtils {

    /**
     * Calculate progress % from previous to current value.
     * If prev is null, returns null.
     * 
     * @param prev previous float value
     * @param current current float value
     * @return percentage progress (positive or negative), or null if prev is null
     */
    public static Float calcProgress(Float prev, Float current) {
        if (prev == null || current == null) return null;
        if (prev == 0f) return null;  // avoid division by zero
        return ((current - prev) / prev) * 100;
    }
}
