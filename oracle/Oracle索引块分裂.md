When an index block in Oracle becomes full and needs to be split, Oracle internally performs the following steps to split the index block:

1. Identify the Split Point: Oracle determines the split point within the full index block. The split point is the value that will be promoted to the parent index block, indicating the separation between the two resulting index blocks.

2. Allocate New Block: Oracle allocates a new block to accommodate the split data. This new block will become the sibling block of the original block.

3. Adjust Block Pointers: The block pointers within the index block are adjusted to reflect the split. The block pointers before the split point remain in the original block, while the block pointers after the split point are moved to the new block.

4. Update Parent Block: If the split index block has a parent block, Oracle updates the parent block to include the new block pointer for the newly allocated block. This ensures that the parent block correctly references the new block.

5. Update High-Key Value: The high-key value in the split index block is updated to reflect the highest value in the new block.

6. Update Key Values: The key values in the index block are adjusted to accommodate the split. The key values before the split point remain in the original block, while the key values after the split point are moved to the new block.

By splitting the index block, Oracle ensures that the index remains balanced and efficient for subsequent data insertions and updates. Splitting index blocks allows for better space utilization and minimizes the need for further block splits in the future.

It's worth noting that index block splitting is a low-level operation managed internally by Oracle. The details of how Oracle performs the split may vary based on the specific index structure (e.g., B-tree, bitmap) and implementation details within the Oracle database version.