import * as matchers from "@testing-library/jest-dom/matchers";
import { cleanup } from "@testing-library/react";
import { afterEach, expect } from "vitest";

// Add jest-dom matchers to vitest's expect function
expect.extend(matchers);

// Set up the types for the jest-dom matchers
declare module "vitest" {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  interface Assertion<T = any>
    extends jest.Matchers<void, T>,
      matchers.TestingLibraryMatchers<T, void> {}
}

// Clean up the rendered elements after each test
afterEach(() => {
  cleanup();
});
