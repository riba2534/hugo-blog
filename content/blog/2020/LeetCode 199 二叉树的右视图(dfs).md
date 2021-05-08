---
title: LeetCode 199 二叉树的右视图(dfs)
date: 2020-04-22T01:49:22+08:00
lastmod: 2020-04-22T01:49:22+08:00
draft: false
featured_image: "https://image-1252109614.cos.ap-beijing.myqcloud.com/img/20210508201223.png"
tags:
- LeetCode
categories: OnlineJudge刷题
comment: true

---

题目链接：[二叉树的右视图](https://leetcode-cn.com/problems/binary-tree-right-side-view/)

给定一棵二叉树，想象自己站在它的右侧，按照从顶部到底部的顺序，返回从右侧所能看到的节点值。

**示例:**

```
输入: [1,2,3,null,5,null,4]
输出: [1, 3, 4]
解释:

   1            <---
 /   \
2     3         <---
 \     \
  5     4       <---
```

## 思路

题目要求二叉树的右视图，直接用dfs遍历，那么我们就需要尽量往右找，因为可能右子树遍历完了，左子树的深度还有更深的。需要用一个哈希来记录一下，当前层是不是已经找到了最右边的点，找到了就标记一下，没找到就加入到答案的列表中。最后输出结果即可。

## 代码

```cpp
struct TreeNode
{
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(NULL), right(NULL) {}
};

class Solution
{
public:
    vector<pair<int, int>> ans;
    unordered_map<int, int> mp;
    void dfs(TreeNode *node, int deep)
    {
        if (!node)
            return;
        if (mp.find(deep) == mp.end())
        {
            ans.push_back({node->val, deep});
            mp[deep]++;
        }
        if (node->right)
            dfs(node->right, deep + 1);
        if (node->left)
            dfs(node->left, deep + 1);
    }
    vector<int> rightSideView(TreeNode *root)
    {
        dfs(root, 0);
        vector<int> result;
        for (auto [val, deep] : ans)
            result.push_back(val);
        return result;
    }
};
```
